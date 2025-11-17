# Fee Types and Calculation Guide

## Overview

The LAA CCW Fees Service calculates legal aid fees based on various factors including location, case stage, matter codes, and fee types. This guide explains how different fee types work and how they're calculated.

## Fee Type Classifications

The system uses different fee type codes to determine how fees are calculated and applied:

### Type A - Automatic Fees
**Description:** Fixed fees that are automatically available for a given location/case stage/matter code combination, but require user selection.

**How it works:**
- The system returns all available Type A fees for the specified criteria
- The user must **select which level/category** applies to their specific case
- The amount is **fixed in the database** - users cannot modify it
- Once selected, that exact amount is used in the calculation

**Example:**
```json
{
  "locationCode": "LDN",
  "caseStage": "FPL08",
  "matterCode1": "FAMD",
  "matterCode2": "FCHS"
}
```

Returns multiple Type A fees:
- Level 1: £86
- Level 2 children: £230
- Level 2 finance: £241
- Settlement fee finance: £145

**Important:** Even though these are "automatic," not all fees are applied to every case. The user selects the appropriate level (e.g., Level 1 vs Level 2) based on the case complexity.

**Use case:** Standard fees where the amount is predetermined based on the work level/category.

---

### Type O - Optional Fixed Amount
**Description:** Optional fees with a fixed amount defined in the database.

**How it works:**
- User decides whether to include this fee or not
- If included, uses the **fixed amount from the database**
- No units or custom amounts - it's either included or not

**Example:**
```json
{
  "levelCode": "_IMSUH",
  "comment": "Substantive hearing = £302 (fixed from DB)"
}
```

**Use case:** Additional work items that may or may not be needed, with standard pricing (e.g., attending a substantive hearing).

---

### Type OU - Optional Per Unit
**Description:** Optional fees charged per unit of work performed.

**How it works:**
- User specifies the **number of units** performed (e.g., hearings attended)
- Database provides the **per-unit rate**
- Final amount = database rate × number of units

**Example:**
```json
{
  "levelCode": "_IMORL",
  "units": 2.0,
  "comment": "2 oral CMR hearings × £166 = £332"
}
```

Calculation:
- Database rate: £166 per oral CMR hearing
- Units provided: 2
- Total: £166 × 2 = £332

**Use case:** Repeatable activities where the barrister may perform the work multiple times (hearings, consultations, etc.).

---

### Type OF - Optional Fee (User-Specified Amount)
**Description:** Optional fees where the user provides the actual cost incurred.

**How it works:**
- User decides to include this fee category
- User specifies the **exact amount** they're claiming
- The database defines the category, but the user provides the cost

**Example:**
```json
{
  "levelCode": "_IMJRF",
  "fee": 85.50,
  "comment": "JR form filling - actual cost = £85.50"
}
```

**Use case:** Variable-cost items where the actual expense depends on the specific circumstances (e.g., court fees, expert reports, disbursements).

---

## Complete Calculation Example

Here's a full example showing how different fee types work together:

### Request
```json
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

### Breakdown

1. **Base fee** (Type A): Automatically determined by location/case stage/matter codes
2. **2 oral CMR hearings** (Type OU): £166 × 2 = £332
3. **1 telephone CMR hearing** (Type OU): £90 × 1 = £90
4. **Substantive hearing** (Type O): £302 (fixed)
5. **1 adjourned hearing** (Type OU): £161 × 1 = £161
6. **JR form filling** (Type OF): £85.50 (user-specified)

The service calculates the total including VAT based on all selected fees.

---

## Workflow Summary

### Step 1: Determine Available Fees
Call `/v1/fees/list-available` with location, case stage, and matter codes to see all available fee options.

### Step 2: User Selects Applicable Fees

**For Type A (Automatic):**
- Choose the appropriate level/category for the case

**For Type O (Optional Fixed):**
- Decide whether this work was performed
- If yes, include the level code

**For Type OU (Optional Per Unit):**
- Determine how many times the work was performed
- Include the level code and specify units

**For Type OF (Optional Fee):**
- Determine the actual cost incurred
- Include the level code and specify the fee amount

### Step 3: Calculate Total
Call `/v1/fees/calculate` with the selected level codes and their parameters. The service returns:
- Individual fee amounts
- Subtotal
- VAT amount
- Total including VAT

---

## Important Notes

- **Type A fees are not all applied automatically** - the user must select which level/category applies to their specific case
- **All fees for a given level/category are consistent** - every barrister doing the same level of work gets the same fee
- **Optional fees (O, OU, OF) are only included if explicitly specified** in the request
- **VAT is calculated automatically** based on the current rate in the database
- The `formQuestion` field (if present) indicates what question should be asked to determine if a fee applies

---

## API Endpoints

- **GET `/v1/fees/list-available`** - Returns all available fees for given criteria
- **GET `/v1/fees/calculate`** - Calculates total fees based on selected level codes
- **GET `/v1/matter-codes/{lawType}`** - Get matter codes for a law type
- **GET `/v1/matter-codes/{matterCode1}/matter-code-2`** - Get matter code 2 options
- **GET `/v1/case-stages`** - Get available case stages for matter codes

See `api-examples.http` for detailed examples of each endpoint.
