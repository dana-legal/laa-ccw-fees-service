# Interactive Fee Calculator - Complete Workflow

This guide shows how to build a dynamic, step-by-step fee calculator form for your website.

---

## **Step 1: Choose Law Type**

**API Call:**
```http
GET /v1/matter-codes/{lawType}
```

**Available Law Types:** (from your database)
- `FAM` - Family Law
- `IMM` - Immigration Law

**Example:**
```http
GET http://localhost:8086/v1/matter-codes/FAM
```

**Response:**
```json
{
  "matterCodes": [
    {"matterCode": "FAMA"},
    {"matterCode": "FAMC"},
    {"matterCode": "FAMD"}
  ]
}
```

**UI Action:**
- Present law type dropdown: "Family Law" or "Immigration Law"
- When selected, fetch matter codes for that law type
- Store selected law type

---

## **Step 2: Choose Matter Code 1 (Primary Category)**

**API Call:** (same as Step 1)
```http
GET /v1/matter-codes/{lawType}
```

**UI Action:**
- Display dropdown with matter codes from Step 1
- Example for Family Law:
  - FAMA - Divorce/Judicial Separation/Nullity
  - FAMC - Domestic Abuse
  - FAMD - Private Law Children only
- Store selected matterCode1

---

## **Step 3: Choose Matter Code 2 (Sub-category)**

**API Call:**
```http
GET /v1/matter-codes/{matterCode1}/matter-code-2
```

**Example:**
```http
GET http://localhost:8086/v1/matter-codes/FAMA/matter-code-2
```

**Response:**
```json
{
  "matterCodes": [
    {"matterCode": "FPET"},
    {"matterCode": "FRES"},
    {"matterCode": "FADV"}
  ]
}
```

**UI Action:**
- Display dropdown with available matter code 2 options
- Example descriptions:
  - FPET - Client is the petitioner in Divorce
  - FRES - Client is the respondent in Divorce
  - FADV - Client is seeking advice only
- Store selected matterCode2

---

## **Step 4: Choose Case Stage**

**API Call:**
```http
GET /v1/case-stages
Content-Type: application/json

{
  "matterCode1": "{selected from step 2}",
  "matterCode2": "{selected from step 3}"
}
```

**Example:**
```http
GET http://localhost:8086/v1/case-stages
Content-Type: application/json

{
  "matterCode1": "FAMA",
  "matterCode2": "FPET"
}
```

**Response:**
```json
{
  "caseStages": [
    {"caseStage": "FPL01"},
    {"caseStage": "FPL10"}
  ]
}
```

**UI Action:**
- Display dropdown with available case stages
- Example descriptions:
  - FPL01 - Level 1
  - FPL10 - Divorce petition fee
- Store selected caseStage

---

## **Step 5: Choose Provider Location**

**Available Locations:** (from your database)
- `LDN` - London
- `NLDN` - Non-London
- `NA` - Not applicable (for Immigration)

**UI Action:**
- Display dropdown with location options
- For Immigration cases, default to "NA"
- For Family Law cases, show London/Non-London
- Store selected locationCode

---

## **Step 6: Get Available Fees (Build Dynamic Form)**

**API Call:**
```http
GET /v1/fees/list-available
Content-Type: application/json

{
  "locationCode": "{selected from step 5}",
  "caseStage": "{selected from step 4}",
  "matterCode1": "{selected from step 2}",
  "matterCode2": "{selected from step 3}"
}
```

**Example:**
```http
GET http://localhost:8086/v1/fees/list-available
Content-Type: application/json

{
  "locationCode": "NA",
  "caseStage": "_IMM02",
  "matterCode1": "IACF",
  "matterCode2": "IASY"
}
```

**Response:**
```json
{
  "fees": [
    {
      "amount": 1009.0,
      "levelCode": "_IMSTD",
      "levelCodeType": "A",
      "description": "Immigration standard fee",
      "formQuestion": "Immigration standard fee"
    },
    {
      "amount": 166.0,
      "levelCode": "_IMORL",
      "levelCodeType": "OU",
      "description": "CMRH Oral",
      "formQuestion": "Number of Oral CMR hearings"
    },
    {
      "amount": 90.0,
      "levelCode": "_IMTEL",
      "levelCodeType": "OU",
      "description": "CMRH Telephone",
      "formQuestion": "Number of telephone CMR hearings"
    },
    {
      "amount": 302.0,
      "levelCode": "_IMSUH",
      "levelCodeType": "O",
      "description": "Substantive hearing",
      "formQuestion": "Was there a substantive hearing?"
    },
    {
      "amount": 161.0,
      "levelCode": "_IMADJ",
      "levelCodeType": "OU",
      "description": "Adjourned hearing",
      "formQuestion": "Number of adjourned hearings"
    },
    {
      "amount": 0.0,
      "levelCode": "_IMJRF",
      "levelCodeType": "OF",
      "description": "JR form filling costs",
      "formQuestion": "Form filling costs (optional)"
    },
    {
      "amount": 150.0,
      "levelCode": "_IMNRM",
      "levelCodeType": "O",
      "description": "NRM advice",
      "formQuestion": "Was this NRM advice?"
    }
  ]
}
```

**UI Action - Build Dynamic Form:**

For each fee in the response, create form fields based on `levelCodeType`:

### **Type "A" (Automatic) - Display Only**
```
✓ Immigration standard fee: £1,009.00 (included)
```
- No user input needed
- Just display as included in base cost
- Don't add to levelCodes array

### **Type "O" (Optional) - Yes/No Checkbox**
```
☐ Was there a substantive hearing? (+£302.00)
☐ Was this NRM advice? (+£150.00)
```
- Render as checkbox or toggle
- Show the amount that will be added
- If checked, add to levelCodes: `{"levelCode": "_IMSUH"}`

### **Type "OU" (Optional per Unit) - Number Input**
```
Number of Oral CMR hearings: [___] (£166.00 each)
Number of telephone CMR hearings: [___] (£90.00 each)
Number of adjourned hearings: [___] (£161.00 each)
```
- Render as number input (min: 0)
- Show per-unit price
- Calculate preview: units × amount
- If > 0, add to levelCodes: `{"levelCode": "_IMORL", "units": 2.0}`

### **Type "OF" (Optional Fixed - Custom Amount) - Currency Input**
```
☐ Form filling costs (optional): £[___]
```
- Render as checkbox + currency input
- User specifies the actual cost
- If checked and amount entered, add to levelCodes: `{"levelCode": "_IMJRF", "fee": 85.50}`

---

## **Step 7: Calculate Total (Live Preview & Final)**

As the user fills out the form, you can calculate a live preview locally OR call the API.

**API Call:**
```http
GET /v1/fees/calculate
Content-Type: application/json

{
  "locationCode": "NA",
  "caseStage": "_IMM02",
  "matterCode1": "IACF",
  "matterCode2": "IASY",
  "levelCodes": [
    {
      "levelCode": "_IMORL",
      "units": 2.0
    },
    {
      "levelCode": "_IMTEL",
      "units": 1.0
    },
    {
      "levelCode": "_IMSUH"
    },
    {
      "levelCode": "_IMADJ",
      "units": 1.0
    },
    {
      "levelCode": "_IMJRF",
      "fee": 85.50
    }
  ]
}
```

**Response:**
```json
{
  "fees": [
    {
      "feeType": "_IMSTD",
      "amount": "1009.00",
      "vat": "201.80",
      "total": "1210.80",
      "unit": "1.00"
    },
    {
      "feeType": "_IMORL",
      "amount": "332.00",
      "vat": "66.40",
      "total": "398.40",
      "unit": "2.00"
    },
    {
      "feeType": "_IMTEL",
      "amount": "90.00",
      "vat": "18.00",
      "total": "108.00",
      "unit": "1.00"
    },
    {
      "feeType": "_IMSUH",
      "amount": "302.00",
      "vat": "60.40",
      "total": "362.40",
      "unit": "1.00"
    },
    {
      "feeType": "_IMADJ",
      "amount": "161.00",
      "vat": "32.20",
      "total": "193.20",
      "unit": "1.00"
    },
    {
      "feeType": "_IMJRF",
      "amount": "85.50",
      "vat": "17.10",
      "total": "102.60",
      "unit": "1.00"
    },
    {
      "feeType": "totals",
      "amount": "1979.50",
      "vat": "395.90",
      "total": "2375.40",
      "unit": "1.00"
    }
  ]
}
```

**UI Action - Display Breakdown:**
```
Fee Breakdown:
─────────────────────────────────────────────
Immigration standard fee          £1,009.00
2 × Oral CMR hearings              £332.00
1 × Telephone CMR hearings          £90.00
Substantive hearing                £302.00
1 × Adjourned hearings             £161.00
Form filling costs                  £85.50
─────────────────────────────────────────────
Subtotal:                        £1,979.50
VAT (20%):                         £395.90
─────────────────────────────────────────────
TOTAL:                           £2,375.40
═════════════════════════════════════════════
```

---

## **Step 8: Create Invoice (Optional)**

After calculation, save the invoice:

**API Call:**
```http
PUT /v1/invoices/create
Content-Type: application/json

{
  "provider": "Law Firm Name",
  "office": "London Office",
  "amount": 2375.40
}
```

**Response:**
```json
{
  "invoiceId": 123,
  "invoiceNumber": "INV-2025-00123"
}
```

---

## **Complete Example Workflows**

### **Workflow A: Simple Family Law Case**

1. Select: Family Law → FAMA (Divorce) → FPET (Petitioner) → FPL01 (Level 1) → London
2. View fees: Only automatic fee of £86.00
3. No optional fees to add
4. Calculate: £86.00 + £17.20 VAT = **£103.20 total**

### **Workflow B: Complex Immigration Case**

1. Select: Immigration → IACF (Asylum Stage 2) → IASY (Asylum) → _IMM02 → NA
2. View fees: £1,009 base + 6 optional fees available
3. User adds:
   - 2 oral hearings
   - 1 telephone hearing
   - Yes to substantive hearing
   - 1 adjourned hearing
   - £85.50 for form costs
4. Calculate: £1,979.50 + £395.90 VAT = **£2,375.40 total**

---

## **Frontend Implementation Tips**

### **State Management**
```javascript
const [formState, setFormState] = useState({
  lawType: null,
  matterCode1: null,
  matterCode2: null,
  caseStage: null,
  locationCode: null,
  availableFees: [],
  levelCodes: []
});
```

### **Dynamic levelCodes Builder**
```javascript
function handleOptionalFee(levelCode, checked) {
  if (checked) {
    setFormState(prev => ({
      ...prev,
      levelCodes: [...prev.levelCodes, { levelCode }]
    }));
  } else {
    setFormState(prev => ({
      ...prev,
      levelCodes: prev.levelCodes.filter(lc => lc.levelCode !== levelCode)
    }));
  }
}

function handlePerUnitFee(levelCode, units) {
  const numUnits = parseFloat(units);
  if (numUnits > 0) {
    setFormState(prev => ({
      ...prev,
      levelCodes: [
        ...prev.levelCodes.filter(lc => lc.levelCode !== levelCode),
        { levelCode, units: numUnits }
      ]
    }));
  } else {
    // Remove if units is 0
    setFormState(prev => ({
      ...prev,
      levelCodes: prev.levelCodes.filter(lc => lc.levelCode !== levelCode)
    }));
  }
}

function handleFixedAmountFee(levelCode, fee, checked) {
  if (checked && fee > 0) {
    setFormState(prev => ({
      ...prev,
      levelCodes: [
        ...prev.levelCodes.filter(lc => lc.levelCode !== levelCode),
        { levelCode, fee: parseFloat(fee) }
      ]
    }));
  } else {
    setFormState(prev => ({
      ...prev,
      levelCodes: prev.levelCodes.filter(lc => lc.levelCode !== levelCode)
    }));
  }
}
```

### **Progressive Disclosure**
```javascript
// Only show next step when previous is complete
{lawType && <MatterCode1Selector />}
{matterCode1 && <MatterCode2Selector />}
{matterCode2 && <CaseStageSelector />}
{caseStage && <LocationSelector />}
{locationCode && <DynamicFeeForm />}
{levelCodes.length >= 0 && <CalculateButton />}
```

---

## **API Endpoints Summary**

| Step | Endpoint | Purpose |
|------|----------|---------|
| 1-2 | `GET /v1/matter-codes/{lawType}` | Get matter code 1 options |
| 3 | `GET /v1/matter-codes/{matterCode1}/matter-code-2` | Get matter code 2 options |
| 4 | `GET /v1/case-stages` | Get available case stages |
| 6 | `GET /v1/fees/list-available` | Get all fees for dynamic form |
| 7 | `GET /v1/fees/calculate` | Calculate total with selections |
| 8 | `PUT /v1/invoices/create` | Save invoice (optional) |

---

## **Error Handling**

- If any step returns empty results, show message: "No options available for this combination"
- Validate all required fields before allowing calculation
- Handle network errors gracefully
- Show validation errors for invalid amounts/units

---

## **Accessibility & UX**

- Use clear labels from `formQuestion` field
- Show currency formatting: £X,XXX.XX
- Provide live preview of total as user fills form
- Add tooltips with `description` field for clarity
- Mark required vs optional fields clearly
- Show progressive loading states between steps
