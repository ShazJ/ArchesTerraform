# PR - ADD PR TITLE

## Description

Briefly describe the purpose of this PR and the changes introduced to the Terraform project. Reference any related issues or tasks.

**Related Task/Issue**: [#IssueNumber or Link]()

---

## Changes Proposed
- List specific changes to Terraform files, modules, or GitHub Actions workflows (e.g., added `google_storage_bucket` resource, updated `.checkov.yml`).
- Mention updates to `.checkov.yml` skips or suppressions, if any.
- Note changes to CI/CD pipelines (e.g., `.github/workflows/security.yml` or `.github/actions/security/sast/action.yml`).

### Types of Changes
- [ ] New Terraform Resources or Modules
- [ ] Updated Terraform Resources or Modules
- [ ] GitHub Actions Workflow Changes
- [ ] Checkov Configuration Changes (e.g., `.checkov.yml`)
- [ ] Bug Fix (e.g., fixing Terraform syntax or Checkov false positives)
- [ ] Documentation Updates
- [ ] Other (specify: e.g., SBOM generation)
- [ ] Code follows team Terraform conventions (e.g., `terraform fmt`, naming standards)
- [ ] Checkov output reviewed in PR annotations
- [ ] Skipped/suppressed Checkov checks documented and justified
- [ ] No new HIGH/CRITICAL severity security issues introduced
- [ ] Terraform plan reviewed and valid
- [ ] No manual changes made directly to infrastructure

---

### Added Resources or Modules
[List any new resources or modules added, along with a brief description of their purpose.]

- (Add resources/modules as needed)

---

### Workflows Updated
[Detail any changes to existing workflows or new workflows added.]

- (Add workflows as needed)

---

## 🔐 Security Considerations

<!-- Mention any security-impacting changes or known risks -->

- **Sensitive Permissions or Secrets**:
  - Are new IAM roles, permissions, or secrets introduced?  
    ☐ Yes  ☐ No  
    If Yes, describe and justify (e.g., new `google_storage_bucket_iam_binding`).

- **Checkov Warnings**:
  - Are any Checkov checks skipped or suppressed (e.g., in `.checkov.yml` or in-line)?  
    ☐ Yes  ☐ No  
    If Yes, list and justify (e.g., `CKV_GCP_30` skipped for legacy bucket compatibility).

- **SBOM Impact**:
  - Does this PR affect the SBOM (`checkov-results.xml`)?  
    ☐ Yes  ☐ No  
    If Yes, describe (e.g., new resources added to SBOM). 

---
## 📸 Screenshots / Output (if applicable)

<!-- Include `terraform plan` output -->
Paste the relevant `terraform plan` output to show changes (redact sensitive data). Use triple backticks for formatting:

```plaintext
terraform plan
# Example output
+ resource "google_storage_bucket" "example" {
    + name     = "my-bucket"
    + location = "US"
}

---

## 📝 Additional Notes
[Add any additional context, notes, or information that might be relevant to reviewers or testers.]
