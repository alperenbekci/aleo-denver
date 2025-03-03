# Compliant Token with KYC and Blacklist

An Aleo program demonstrating advanced compliance mechanisms for token operations. This program implements KYC verification and blacklist features along with daily transfer limits.

## Workshop Submission Details

This project is submitted for the Aleo Workshop: Compliant Token Challenge.

**Short Explanation of Compliance Mechanism:**
This program introduces three key compliance features:
1. KYC Verification System: A privacy-preserving approach to ensure only verified addresses can participate in transfers
2. Smart Blacklist Management: Automated blocking of suspicious addresses with admin controls
3. Dynamic Daily Limits: Epoch-based transfer limits to prevent market manipulation

**Originality Statement:**
This implementation is original and not forked from existing solutions. The compliance features are implemented from scratch with a focus on privacy and security.

**Submission Timeline:**
- Submission Date: [Your submission date]
- Workshop Period: 2/27/25 to 3/1/25

## Features

1. **KYC Verification**
   - Track KYC status for each address
   - Only KYC-verified addresses can initiate transfers
   - KYC status management by admin
   - Privacy-preserving compliance verification

2. **Blacklist Mechanism**
   - Block transfers to/from suspicious addresses
   - Automated blacklist checks during transfers
   - Admin-controlled blacklist management
   - Enhanced security against malicious actors

3. **Daily Transfer Limits**
   - Per-user daily transfer limits
   - Epoch-based limit reset
   - Automated limit enforcement
   - Protection against excessive transfers

## Technical Implementation

- **Smart Contract Security**
  - Admin-only access for compliance controls
  - Automated compliance checks before transfers
  - Daily limit enforcement through epochs
  - Immutable transaction records

- **Privacy Features**
  - Private transfer mechanism
  - Secure KYC status verification
  - Protected user transaction history
  - Compliant with privacy regulations


deployed at: at174c9qfa92jqzfzzj7zlr35mymfhr6ptcv7da8uvmxcrqecydzs8sc84z6g
signature: sign1ghugarst375tm7s6hc6vwvu6gfm49ywgrydfe6nm37at7ae50yqhf7mue4pa5gnscs0t87qphzlamsnjse287ykg2yvkd6emntxqxqtkclelpcstlupmc3zfsx2ax0f3rd3sl23prpezdv0yrpd0v4lxpvygvm3zapntfw6q0m8px2sx546krtmhtu2yc4j6aw7vn2ujuytqufv64uk
