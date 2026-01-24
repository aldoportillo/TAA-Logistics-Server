# E-Signature Compliance & Required Fields (DOT / Employment)

This document outlines **regulatory requirements**, **consent language**, and **minimum required data fields** for collecting legally defensible electronic signatures for the TAA Logistics employment application.

---

## 1. Applicable Regulations

### 1.1 ESIGN Act (Federal)

Electronic Signatures in Global and National Commerce Act.

Requires:

* Affirmative consent to use electronic records
* Intent to sign
* Attribution (who signed)
* Record retention in an accurate, reproducible form

A simple boolean checkbox **alone is NOT sufficient**.

---

### 1.2 UETA (Uniform Electronic Transactions Act)

Adopted by 49 U.S. states.

Requires:

* Agreement to conduct business electronically
* Association of the signature with the record
* Record integrity (tamper resistance)

---

### 1.3 DOT / FMCSA Regulations

Relevant sections include 49 CFR Parts 391 and 40.

DOT permits electronic signatures but expects:

* Verifiable signer identity
* Non-repudiation
* Audit trail
* Long-term retention (typically 3+ years; often 7–10 years in practice)

---

## 2. What Must Be Provable

In the event of audit or dispute, the system must prove:

* The applicant consented to electronic records
* The applicant intended to sign
* The identity of the signer
* The exact document that was signed
* The date and time of signing
* That the document was not altered after signing

---

## 3. Required Consent Language (Must Be Displayed)

The following (or substantially similar) language must be shown **before signing**:

> "By checking this box and typing my name, I consent to the use of electronic records and electronic signatures. I understand that my electronic signature is the legal equivalent of my handwritten signature."

**Important:**

* Store the **exact text shown** to the applicant
* Do not rely on a version reference alone

---

## 4. Minimum Required Database Fields

These fields represent a **legally defensible minimum**.

### 4.1 Consent Evidence

* `esign_consent` (boolean, required)
* `esign_consent_at` (timestamp)
* `esign_consent_text` (text)

---

### 4.2 Signature Capture

* `signature_full_name`
* `signature_method`
  (e.g. typed, drawn, checkbox+typed)
* `signature_timestamp`

---

### 4.3 Attribution & Audit Metadata

* `signing_ip_address`
* `signing_user_agent`

---

### 4.4 Document Integrity

* `document_version`
* `document_hash` (recommended: SHA-256 of PDF or rendered document)

This allows proof that:

* The exact document was signed
* The document has not been modified post-signature

---

## 5. Retention Requirements

Recommended retention policy:

* Employment application + signature metadata: **minimum 3 years**
* Best practice for motor carriers: **7–10 years**

Do not allow deletion without an explicit retention policy.

---

## 6. What Is NOT Required

The following are **not legally required**:

* Signature drawing pad
* Biometrics
* Third-party e-sign vendors

Typed-name signatures are valid **if consent and attribution are properly captured**.

---

## 7. When a Boolean Alone Is Acceptable (Rare Case)

Only acceptable if:

* Signature is handled entirely by a third-party provider (e.g. DocuSign)
* You store the envelope / transaction ID
* You can retrieve a full audit trail on demand

Even then, storing basic metadata is strongly recommended.

---

## 8. Recommended Safe Baseline

For DOT-safe, court-defensible compliance:

* Checkbox consent
* Typed full legal name
* Timestamp
* IP address + user agent
* Stored consent language
* Document hash

This meets ESIGN, UETA, and FMCSA expectations without over-engineering.

---

## 9. Implementation Notes (Non-Legal)

* Treat signatures like financial transactions
* Never overwrite signature data
* Version documents explicitly
* Log changes immutably

---

## 10. Data-Only Storage With Deterministic Rendering

Storing only structured data (instead of a binary PDF) **is acceptable** under ESIGN, UETA, and DOT/FMCSA **if and only if** the signed document can be accurately reproduced later.

To be compliant:

* The document template **must be versioned and immutable** once used
* The exact template used at signing time must be identifiable
* The rendering process must be deterministic
* Signature and consent evidence must be stored alongside the data

Failure in any of these areas invalidates the approach.

---

## 11. Required Steps for Data-Only + Print-On-Demand

### Step 1: Template Versioning

* Assign a unique version identifier to each application template
* Never modify an existing template version
* New changes require a new version

Example:

```
taa_application_v1.0
taa_application_v1.1
```

---

### Step 2: Template Hashing

* Compute a cryptographic hash (recommended: SHA-256) of the template file
* Store this hash at the time of signature

This proves which document was signed.

---

### Step 3: Deterministic Rendering

Rendering the document later must produce the **same semantic document** every time.

Avoid:

* Injecting current timestamps at render time
* Conditional sections not present at signing
* Layout changes tied to updated code paths

---

### Step 4: Render Engine Versioning

* Version the rendering engine or PDF generator
* Store the render engine version used at signing

This protects against future output differences caused by library upgrades.

---

### Step 5: On-Demand Reconstruction

At audit or dispute time, the system must be able to:

* Load the stored data row
* Load the stored template version
* Use the stored render engine version
* Produce the reconstructed document promptly

---

## 12. Roadmap for Safe Implementation

### Phase 1: Initial Compliance (MVP)

* Capture consent checkbox
* Capture typed full legal name
* Store consent language verbatim
* Store timestamp, IP address, and user agent
* Lock template version

---

### Phase 2: Integrity & Audit Safety

* Add template hashing
* Add document version tracking
* Add render engine version tracking
* Prevent edits to signed records

---

### Phase 3: Operational Hardening

* Add retention enforcement (3–10 years)
* Add immutable audit logging
* Add admin-only document reconstruction

---

### Phase 4: Optional Enhancements

* Generate and store final PDF upon hire
* External e-sign integration (DocuSign / Adobe Sign)
* Automated compliance reports

---

**Status:** Compliance + Architecture Reference
**Audience:** Engineering, Compliance, Auditors
