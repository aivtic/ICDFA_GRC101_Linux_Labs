# Week 2 Linux Lab: Regulatory Environment and Standards
## Student Lab Manual

**International Cybersecurity and Digital Forensics Academy (ICDFA)**  
**Course: GRC101 - Introduction to Governance, Risk, and Compliance**  
**Lab Duration: 3 hours**  
**Student Name: _________________ Date: _________________**

---

## Lab Introduction

Welcome to Week 2's hands-on regulatory compliance lab! In this lab, you will learn to implement practical compliance monitoring and reporting systems for major regulatory frameworks using Linux tools. You'll work with GDPR, SOX, HIPAA, and PCI DSS compliance requirements, learning how to use Linux security features to meet regulatory obligations.

### What You Will Learn
- Implement GDPR data protection and privacy controls
- Create SOX-compliant audit trails and financial data protection
- Set up HIPAA-compliant access controls and PHI protection
- Implement PCI DSS security monitoring and vulnerability scanning
- Generate automated regulatory compliance reports
- Understand how Linux supports regulatory compliance requirements

### What You Need
- Completion of Week 1 Linux Lab
- Access to a Linux system (Ubuntu 22.04 or similar)
- Understanding of major regulatory frameworks
- Internet connection for package installation
- Basic knowledge of encryption and access controls

---

## Pre-Lab Setup

Before starting the exercises, ensure your system has the required regulatory compliance tools installed.

### Step 1: Update Your System
```bash
# Update package lists and upgrade system
sudo apt update && sudo apt upgrade -y
```

### Step 2: Install Regulatory Compliance Tools
```bash
# Install web servers and databases for compliance testing
sudo apt install -y apache2 nginx mysql-server postgresql

# Install security and compliance tools
sudo apt install -y lynis clamav clamav-daemon fail2ban
sudo apt install -y openssl ca-certificates
sudo apt install -y rsyslog logrotate

# Install monitoring and analysis tools
sudo apt install -y htop iotop net-tools nmap
sudo apt install -y jq xmlstarlet csvkit

# Install encryption and privacy tools
sudo apt install -y gnupg2 cryptsetup ecryptfs-utils
```

### Step 3: Verify Installation
```bash
# Check if compliance tools are installed correctly
which openssl && echo "OpenSSL installed successfully"
which fail2ban-client && echo "Fail2ban installed successfully"
which nmap && echo "Nmap installed successfully"
which lynis && echo "Lynis installed successfully"
```

### Step 4: Create Lab Workspace
```bash
# Create main regulatory compliance workspace
mkdir -p ~/regulatory_compliance/{gdpr,sox,hipaa,pci_dss}
cd ~/regulatory_compliance
```

---

## Exercise 1: GDPR Data Protection Implementation

**Time Allocation: 60 minutes**

In this exercise, you'll implement GDPR (General Data Protection Regulation) compliance using Linux encryption, access controls, and audit logging.

### Learning Objectives
- Implement data encryption for personal data protection
- Create access control systems for data subject rights
- Set up comprehensive audit logging for data processing
- Develop breach detection and notification systems

### Part A: Setting Up GDPR Infrastructure

1. **Create GDPR compliance directory structure:**
```bash
# Create comprehensive GDPR structure
mkdir -p ~/regulatory_compliance/gdpr/{data,logs,reports,scripts,policies,keys}
mkdir -p ~/regulatory_compliance/gdpr/data/{encrypted,processed,archived,subjects}
mkdir -p ~/regulatory_compliance/gdpr/logs/{access,processing,deletion,consent}
cd ~/regulatory_compliance/gdpr
```

2. **Set up GDPR user groups:**
```bash
# Create GDPR-specific groups (if you have sudo access)
# Note: If you don't have sudo access, skip group creation and use existing groups
sudo groupadd gdpr-admin 2>/dev/null || echo "Group creation skipped - using existing groups"
sudo groupadd data-processor 2>/dev/null || echo "Group creation skipped - using existing groups"
sudo groupadd data-subject 2>/dev/null || echo "Group creation skipped - using existing groups"

# Add yourself to relevant groups
sudo usermod -a -G gdpr-admin $USER 2>/dev/null || echo "Group assignment skipped"
```

3. **Configure directory permissions:**
```bash
# Set appropriate permissions for GDPR directories
chmod 750 ~/regulatory_compliance/gdpr
chmod 700 ~/regulatory_compliance/gdpr/data
chmod 755 ~/regulatory_compliance/gdpr/logs
chmod 700 ~/regulatory_compliance/gdpr/keys
```

### Part B: Personal Data Encryption System

1. **Create encryption key management:**
```bash
# Generate master encryption key for GDPR compliance
mkdir -p keys
openssl rand -base64 32 > keys/gdpr_master.key
chmod 600 keys/gdpr_master.key

echo "Master encryption key generated for GDPR compliance"
```

2. **Create personal data encryption script:**
```bash
# Create data encryption script
cat > scripts/encrypt_personal_data.sh << 'EOF'
#!/bin/bash
# GDPR Personal Data Encryption Script

GDPR_BASE="$HOME/regulatory_compliance/gdpr"
ENCRYPTION_KEY="$GDPR_BASE/keys/gdpr_master.key"
LOG_FILE="$GDPR_BASE/logs/processing/encryption.log"

# Function to encrypt personal data
encrypt_personal_data() {
    local input_file=$1
    local output_file=$2
    local data_subject=$3
    
    if [ ! -f "$input_file" ]; then
        echo "Error: Input file $input_file not found"
        return 1
    fi
    
    if [ ! -f "$ENCRYPTION_KEY" ]; then
        echo "Error: Encryption key not found"
        return 1
    fi
    
    # Encrypt the file
    openssl enc -aes-256-cbc -salt -in "$input_file" -out "$output_file" -pass file:"$ENCRYPTION_KEY"
    
    if [ $? -eq 0 ]; then
        echo "Successfully encrypted: $input_file -> $output_file"
        
        # Log the encryption activity for GDPR compliance
        echo "$(date '+%Y-%m-%d %H:%M:%S')|ENCRYPT|$data_subject|$input_file|$output_file|$(whoami)" >> "$LOG_FILE"
        
        # Remove original unencrypted file for security
        rm "$input_file"
        echo "Original unencrypted file removed for security"
    else
        echo "Error: Encryption failed"
        return 1
    fi
}

# Function to decrypt personal data
decrypt_personal_data() {
    local encrypted_file=$1
    local output_file=$2
    local data_subject=$3
    local purpose=$4
    
    if [ ! -f "$encrypted_file" ]; then
        echo "Error: Encrypted file $encrypted_file not found"
        return 1
    fi
    
    # Decrypt the file
    openssl enc -aes-256-cbc -d -in "$encrypted_file" -out "$output_file" -pass file:"$ENCRYPTION_KEY"
    
    if [ $? -eq 0 ]; then
        echo "Successfully decrypted: $encrypted_file -> $output_file"
        
        # Log the decryption activity for GDPR compliance
        echo "$(date '+%Y-%m-%d %H:%M:%S')|DECRYPT|$data_subject|$encrypted_file|$output_file|$(whoami)|$purpose" >> "$LOG_FILE"
    else
        echo "Error: Decryption failed"
        return 1
    fi
}

# Main script logic
case "$1" in
    "encrypt")
        if [ $# -ne 4 ]; then
            echo "Usage: $0 encrypt <input_file> <output_file> <data_subject>"
            exit 1
        fi
        encrypt_personal_data "$2" "$3" "$4"
        ;;
    "decrypt")
        if [ $# -ne 5 ]; then
            echo "Usage: $0 decrypt <encrypted_file> <output_file> <data_subject> <purpose>"
            exit 1
        fi
        decrypt_personal_data "$2" "$3" "$4" "$5"
        ;;
    *)
        echo "Usage: $0 {encrypt|decrypt} [arguments]"
        echo "  encrypt: $0 encrypt <input_file> <output_file> <data_subject>"
        echo "  decrypt: $0 decrypt <encrypted_file> <output_file> <data_subject> <purpose>"
        exit 1
        ;;
esac
EOF

# Make the script executable
chmod +x scripts/encrypt_personal_data.sh
```

3. **Test the encryption system:**
```bash
# Create sample personal data file
cat > data/sample_personal_data.txt << 'EOF'
Personal Data Record
===================
Name: John Doe
Email: john.doe@example.com
Phone: +1-555-0123
Address: 123 Main St, Anytown, USA
Date of Birth: 1985-06-15
Social Security: XXX-XX-1234
EOF

# Encrypt the personal data
./scripts/encrypt_personal_data.sh encrypt data/sample_personal_data.txt data/encrypted/john_doe.enc "john_doe"

# Verify encryption worked
ls -la data/encrypted/
cat logs/processing/encryption.log
```

### Part C: Data Subject Rights Implementation

1. **Create data subject rights management script:**
```bash
# Create data subject rights script
cat > scripts/data_subject_rights.sh << 'EOF'
#!/bin/bash
# GDPR Data Subject Rights Management Script

GDPR_BASE="$HOME/regulatory_compliance/gdpr"
RIGHTS_LOG="$GDPR_BASE/logs/access/data_subject_rights.log"
REPORTS_DIR="$GDPR_BASE/reports"

mkdir -p "$REPORTS_DIR"

# Function to handle data access requests (Article 15)
handle_access_request() {
    local subject_id=$1
    local requester=$2
    local request_id="ACCESS_$(date +%Y%m%d_%H%M%S)"
    
    echo "Processing data access request for subject: $subject_id"
    
    # Log the request
    echo "$(date '+%Y-%m-%d %H:%M:%S')|ACCESS_REQUEST|$subject_id|$requester|$request_id" >> "$RIGHTS_LOG"
    
    # Search for personal data across all directories
    local report_file="$REPORTS_DIR/access_request_${subject_id}_$(date +%Y%m%d).txt"
    
    echo "=== GDPR DATA ACCESS REQUEST REPORT ===" > "$report_file"
    echo "Subject ID: $subject_id" >> "$report_file"
    echo "Requester: $requester" >> "$report_file"
    echo "Request ID: $request_id" >> "$report_file"
    echo "Date: $(date)" >> "$report_file"
    echo "" >> "$report_file"
    
    echo "=== PERSONAL DATA FOUND ===" >> "$report_file"
    
    # Search for files containing the subject ID
    find "$GDPR_BASE/data" -type f -name "*$subject_id*" >> "$report_file" 2>/dev/null
    
    # Search for references in logs
    echo "" >> "$report_file"
    echo "=== LOG REFERENCES ===" >> "$report_file"
    grep -r "$subject_id" "$GDPR_BASE/logs" >> "$report_file" 2>/dev/null || echo "No log references found" >> "$report_file"
    
    echo "Access request report generated: $report_file"
    echo "$(date '+%Y-%m-%d %H:%M:%S')|ACCESS_COMPLETED|$subject_id|$requester|$request_id|$report_file" >> "$RIGHTS_LOG"
}

# Function to handle data deletion requests (Article 17 - Right to be Forgotten)
handle_deletion_request() {
    local subject_id=$1
    local requester=$2
    local reason=$3
    local request_id="DELETE_$(date +%Y%m%d_%H%M%S)"
    
    echo "Processing data deletion request for subject: $subject_id"
    echo "Reason: $reason"
    
    # Log the request
    echo "$(date '+%Y-%m-%d %H:%M:%S')|DELETION_REQUEST|$subject_id|$requester|$request_id|$reason" >> "$RIGHTS_LOG"
    
    # Create backup before deletion (for legal compliance)
    local backup_dir="$GDPR_BASE/data/deletion_backups/$request_id"
    mkdir -p "$backup_dir"
    
    # Find and backup files before deletion
    find "$GDPR_BASE/data" -name "*$subject_id*" -type f -exec cp {} "$backup_dir/" \; 2>/dev/null
    
    # Count files to be deleted
    local file_count=$(find "$GDPR_BASE/data" -name "*$subject_id*" -type f | wc -l)
    
    if [ "$file_count" -gt 0 ]; then
        echo "Found $file_count files to delete"
        
        # Delete the personal data files
        find "$GDPR_BASE/data" -name "*$subject_id*" -type f -delete 2>/dev/null
        
        echo "Personal data deleted for subject: $subject_id"
        echo "Backup created in: $backup_dir"
        
        # Log the completion
        echo "$(date '+%Y-%m-%d %H:%M:%S')|DELETION_COMPLETED|$subject_id|$requester|$request_id|$file_count files deleted" >> "$RIGHTS_LOG"
    else
        echo "No personal data found for subject: $subject_id"
        echo "$(date '+%Y-%m-%d %H:%M:%S')|DELETION_NO_DATA|$subject_id|$requester|$request_id|No data found" >> "$RIGHTS_LOG"
    fi
}

# Function to handle data portability requests (Article 20)
handle_portability_request() {
    local subject_id=$1
    local requester=$2
    local format=$3
    local request_id="PORTABILITY_$(date +%Y%m%d_%H%M%S)"
    
    echo "Processing data portability request for subject: $subject_id"
    echo "Requested format: $format"
    
    # Log the request
    echo "$(date '+%Y-%m-%d %H:%M:%S')|PORTABILITY_REQUEST|$subject_id|$requester|$request_id|$format" >> "$RIGHTS_LOG"
    
    local export_file="$REPORTS_DIR/data_export_${subject_id}_$(date +%Y%m%d).$format"
    
    case "$format" in
        "json")
            echo "{" > "$export_file"
            echo "  \"subject_id\": \"$subject_id\"," >> "$export_file"
            echo "  \"export_date\": \"$(date)\"," >> "$export_file"
            echo "  \"data\": [" >> "$export_file"
            # Add actual data export logic here
            echo "  ]" >> "$export_file"
            echo "}" >> "$export_file"
            ;;
        "csv")
            echo "subject_id,data_type,value,date_created" > "$export_file"
            # Add actual data export logic here
            ;;
        *)
            echo "Unsupported format: $format"
            return 1
            ;;
    esac
    
    echo "Data portability export created: $export_file"
    echo "$(date '+%Y-%m-%d %H:%M:%S')|PORTABILITY_COMPLETED|$subject_id|$requester|$request_id|$export_file" >> "$RIGHTS_LOG"
}

# Main script logic
case "$1" in
    "access")
        if [ $# -ne 3 ]; then
            echo "Usage: $0 access <subject_id> <requester>"
            exit 1
        fi
        handle_access_request "$2" "$3"
        ;;
    "delete")
        if [ $# -ne 4 ]; then
            echo "Usage: $0 delete <subject_id> <requester> <reason>"
            exit 1
        fi
        handle_deletion_request "$2" "$3" "$4"
        ;;
    "portability")
        if [ $# -ne 4 ]; then
            echo "Usage: $0 portability <subject_id> <requester> <format>"
            exit 1
        fi
        handle_portability_request "$2" "$3" "$4"
        ;;
    *)
        echo "Usage: $0 {access|delete|portability} [arguments]"
        echo "  access: $0 access <subject_id> <requester>"
        echo "  delete: $0 delete <subject_id> <requester> <reason>"
        echo "  portability: $0 portability <subject_id> <requester> <format>"
        exit 1
        ;;
esac
EOF

# Make the script executable
chmod +x scripts/data_subject_rights.sh
```

2. **Test data subject rights:**
```bash
# Test access request
./scripts/data_subject_rights.sh access john_doe "John Doe"

# View the generated report
cat reports/access_request_john_doe_*.txt

# Test data portability
./scripts/data_subject_rights.sh portability john_doe "John Doe" json

# View the rights log
cat logs/access/data_subject_rights.log
```

### ✅ Checkpoint 1
**Verify your GDPR implementation:**
- [ ] GDPR directory structure created
- [ ] Encryption system working
- [ ] Personal data encrypted successfully
- [ ] Data subject rights scripts functional
- [ ] Access request reports generated
- [ ] Audit logs created

---

## Exercise 2: SOX Compliance Audit Trail Implementation

**Time Allocation: 75 minutes**

In this exercise, you'll implement Sarbanes-Oxley (SOX) compliance through comprehensive audit trails, segregation of duties, and financial data protection.

### Learning Objectives
- Create comprehensive audit logging for financial operations
- Implement segregation of duties through access controls
- Set up tamper-evident log protection
- Develop automated SOX compliance monitoring

### Part A: SOX Infrastructure Setup

1. **Create SOX compliance directory structure:**
```bash
# Create comprehensive SOX structure
mkdir -p ~/regulatory_compliance/sox/{database,logs,reports,scripts,controls,integrity}
mkdir -p ~/regulatory_compliance/sox/logs/{access,changes,admin,financial,audit}
mkdir -p ~/regulatory_compliance/sox/database/{financial_data,backups,archives}
cd ~/regulatory_compliance/sox
```

2. **Set up SOX user groups and permissions:**
```bash
# Create SOX-specific groups (if you have sudo access)
sudo groupadd sox-admin 2>/dev/null || echo "Group creation skipped"
sudo groupadd financial-user 2>/dev/null || echo "Group creation skipped"
sudo groupadd sox-auditor 2>/dev/null || echo "Group creation skipped"

# Set directory permissions
chmod 750 ~/regulatory_compliance/sox
chmod 700 ~/regulatory_compliance/sox/database
chmod 755 ~/regulatory_compliance/sox/logs
chmod 700 ~/regulatory_compliance/sox/integrity
```

3. **Configure system auditing for SOX compliance:**
```bash
# Check if auditd is available and running
if command -v auditctl >/dev/null 2>&1; then
    echo "Audit system available"
    # Note: These commands require sudo access
    echo "To configure SOX auditing, run these commands with sudo:"
    echo "sudo auditctl -w $HOME/regulatory_compliance/sox/database -p rwxa -k sox_financial_data"
    echo "sudo auditctl -w $HOME/regulatory_compliance/sox/logs -p wa -k sox_log_access"
else
    echo "Audit system not available - using custom logging"
fi
```

### Part B: Financial Transaction Logging System

1. **Create financial transaction logging script:**
```bash
# Create comprehensive financial transaction logging
cat > scripts/financial_transaction_logger.sh << 'EOF'
#!/bin/bash
# SOX Financial Transaction Logging Script

SOX_BASE="$HOME/regulatory_compliance/sox"
TRANSACTION_LOG="$SOX_BASE/logs/financial/transactions.log"
AUDIT_LOG="$SOX_BASE/logs/audit/sox_audit.log"
ACCESS_LOG="$SOX_BASE/logs/access/financial_access.log"

# Ensure log directories exist
mkdir -p "$(dirname "$TRANSACTION_LOG")"
mkdir -p "$(dirname "$AUDIT_LOG")"
mkdir -p "$(dirname "$ACCESS_LOG")"

# Function to log financial transactions
log_financial_transaction() {
    local user=$1
    local action=$2
    local amount=$3
    local account=$4
    local description=$5
    local transaction_id="TXN_$(date +%Y%m%d_%H%M%S)_$$"
    
    # Create detailed transaction log entry
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local log_entry="$timestamp|$transaction_id|$user|$action|$amount|$account|$description|$(hostname)"
    
    # Log to transaction log
    echo "$log_entry" >> "$TRANSACTION_LOG"
    
    # Log to SOX audit log
    echo "$timestamp|FINANCIAL_TRANSACTION|User:$user|Action:$action|Amount:$amount|Account:$account|TxnID:$transaction_id" >> "$AUDIT_LOG"
    
    # Log to system log if available
    logger -t SOX_FINANCIAL "User: $user, Action: $action, Amount: $amount, Account: $account, TxnID: $transaction_id" 2>/dev/null || true
    
    echo "Transaction logged: $transaction_id"
    echo "User: $user, Action: $action, Amount: $amount, Account: $account"
}

# Function to log financial data access
log_financial_access() {
    local user=$1
    local resource=$2
    local action=$3
    local purpose=$4
    
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local access_id="ACCESS_$(date +%Y%m%d_%H%M%S)_$$"
    
    # Log financial data access
    echo "$timestamp|$access_id|$user|$resource|$action|$purpose|$(hostname)" >> "$ACCESS_LOG"
    
    # Log to SOX audit log
    echo "$timestamp|FINANCIAL_ACCESS|User:$user|Resource:$resource|Action:$action|Purpose:$purpose|AccessID:$access_id" >> "$AUDIT_LOG"
    
    echo "Financial access logged: $access_id"
}

# Function to check segregation of duties
check_segregation_of_duties() {
    local user=$1
    
    # Get user's groups (simplified check)
    local user_roles=""
    if groups "$user" 2>/dev/null | grep -q "financial-user"; then
        user_roles="$user_roles financial-user"
    fi
    if groups "$user" 2>/dev/null | grep -q "sox-auditor"; then
        user_roles="$user_roles sox-auditor"
    fi
    if groups "$user" 2>/dev/null | grep -q "sox-admin"; then
        user_roles="$user_roles sox-admin"
    fi
    
    # Check for role conflicts
    if echo "$user_roles" | grep -q "financial-user" && echo "$user_roles" | grep -q "sox-auditor"; then
        echo "SOX VIOLATION: User $user has conflicting roles (financial-user and sox-auditor)"
        echo "$(date '+%Y-%m-%d %H:%M:%S')|SOX_VIOLATION|ROLE_CONFLICT|User:$user|Roles:$user_roles" >> "$AUDIT_LOG"
        return 1
    fi
    
    echo "Segregation of duties check passed for user: $user"
    return 0
}

# Main script logic
case "$1" in
    "transaction")
        if [ $# -ne 6 ]; then
            echo "Usage: $0 transaction <user> <action> <amount> <account> <description>"
            exit 1
        fi
        log_financial_transaction "$2" "$3" "$4" "$5" "$6"
        ;;
    "access")
        if [ $# -ne 5 ]; then
            echo "Usage: $0 access <user> <resource> <action> <purpose>"
            exit 1
        fi
        log_financial_access "$2" "$3" "$4" "$5"
        ;;
    "check_roles")
        if [ $# -ne 2 ]; then
            echo "Usage: $0 check_roles <user>"
            exit 1
        fi
        check_segregation_of_duties "$2"
        ;;
    *)
        echo "Usage: $0 {transaction|access|check_roles} [arguments]"
        echo "  transaction: $0 transaction <user> <action> <amount> <account> <description>"
        echo "  access: $0 access <user> <resource> <action> <purpose>"
        echo "  check_roles: $0 check_roles <user>"
        exit 1
        ;;
esac
EOF

# Make the script executable
chmod +x scripts/financial_transaction_logger.sh
```

2. **Test the financial logging system:**
```bash
# Test transaction logging
./scripts/financial_transaction_logger.sh transaction "john_doe" "DEBIT" "1500.00" "ACC_12345" "Office supplies purchase"

./scripts/financial_transaction_logger.sh transaction "jane_smith" "CREDIT" "2500.00" "ACC_67890" "Customer payment received"

# Test access logging
./scripts/financial_transaction_logger.sh access "john_doe" "financial_reports.xlsx" "READ" "Monthly review"

# Test role checking
./scripts/financial_transaction_logger.sh check_roles "$USER"

# View the logs
echo "=== Transaction Log ==="
cat logs/financial/transactions.log

echo -e "\n=== Access Log ==="
cat logs/access/financial_access.log

echo -e "\n=== Audit Log ==="
cat logs/audit/sox_audit.log
```

### Part C: Log Integrity Protection

1. **Create log integrity protection script:**
```bash
# Create log integrity protection system
cat > scripts/log_integrity.sh << 'EOF'
#!/bin/bash
# SOX Log Integrity Protection Script

SOX_BASE="$HOME/regulatory_compliance/sox"
INTEGRITY_DIR="$SOX_BASE/integrity"
LOG_DIR="$SOX_BASE/logs"

mkdir -p "$INTEGRITY_DIR"

# Function to create log checksums
create_log_checksums() {
    local checksum_file="$INTEGRITY_DIR/log_checksums_$(date +%Y%m%d_%H%M%S).sha256"
    
    echo "Creating log integrity checksums..."
    
    # Create checksums for all log files
    find "$LOG_DIR" -type f -name "*.log" -exec sha256sum {} \; > "$checksum_file"
    
    # Create a summary
    local log_count=$(wc -l < "$checksum_file")
    echo "# SOX Log Integrity Checksums" >> "$checksum_file"
    echo "# Created: $(date)" >> "$checksum_file"
    echo "# Total log files: $log_count" >> "$checksum_file"
    echo "# System: $(hostname)" >> "$checksum_file"
    
    # If GPG is available, sign the checksum file
    if command -v gpg >/dev/null 2>&1; then
        # Generate a key if none exists (for demo purposes)
        if ! gpg --list-secret-keys | grep -q "SOX Compliance"; then
            echo "Generating GPG key for log signing..."
            cat > /tmp/gpg_batch << GPGEOF
%echo Generating SOX compliance key
Key-Type: RSA
Key-Length: 2048
Subkey-Type: RSA
Subkey-Length: 2048
Name-Real: SOX Compliance
Name-Email: sox@example.com
Expire-Date: 1y
%no-protection
%commit
%echo done
GPGEOF
            gpg --batch --generate-key /tmp/gpg_batch 2>/dev/null
            rm /tmp/gpg_batch
        fi
        
        # Sign the checksum file
        gpg --armor --detach-sign --default-key "SOX Compliance" "$checksum_file" 2>/dev/null
        echo "Checksum file signed with GPG"
    fi
    
    echo "Log checksums created: $checksum_file"
    
    # Log the integrity check creation
    echo "$(date '+%Y-%m-%d %H:%M:%S')|INTEGRITY_CHECK_CREATED|$checksum_file|$log_count files" >> "$SOX_BASE/logs/audit/sox_audit.log"
}

# Function to verify log integrity
verify_log_integrity() {
    local checksum_file=$1
    
    if [ ! -f "$checksum_file" ]; then
        echo "Error: Checksum file not found: $checksum_file"
        return 1
    fi
    
    echo "Verifying log integrity using: $checksum_file"
    
    # Verify GPG signature if it exists
    if [ -f "$checksum_file.asc" ]; then
        if gpg --verify "$checksum_file.asc" "$checksum_file" 2>/dev/null; then
            echo "✓ GPG signature verified"
        else
            echo "✗ WARNING: GPG signature verification failed"
            return 1
        fi
    fi
    
    # Verify checksums (only check files that still exist)
    local failed_count=0
    local total_count=0
    
    while IFS= read -r line; do
        # Skip comment lines
        if [[ "$line" =~ ^# ]]; then
            continue
        fi
        
        # Extract checksum and filename
        local expected_checksum=$(echo "$line" | awk '{print $1}')
        local filename=$(echo "$line" | awk '{print $2}')
        
        if [ -f "$filename" ]; then
            total_count=$((total_count + 1))
            local actual_checksum=$(sha256sum "$filename" | awk '{print $1}')
            
            if [ "$expected_checksum" = "$actual_checksum" ]; then
                echo "✓ $filename"
            else
                echo "✗ $filename - INTEGRITY VIOLATION"
                failed_count=$((failed_count + 1))
            fi
        fi
    done < "$checksum_file"
    
    echo "Integrity verification completed:"
    echo "  Total files checked: $total_count"
    echo "  Failed checks: $failed_count"
    
    # Log the integrity verification
    echo "$(date '+%Y-%m-%d %H:%M:%S')|INTEGRITY_VERIFICATION|$checksum_file|Total:$total_count|Failed:$failed_count" >> "$SOX_BASE/logs/audit/sox_audit.log"
    
    if [ "$failed_count" -eq 0 ]; then
        echo "✓ All log files passed integrity verification"
        return 0
    else
        echo "✗ WARNING: $failed_count log files failed integrity verification"
        return 1
    fi
}

# Function to list available checksum files
list_checksum_files() {
    echo "Available checksum files:"
    ls -la "$INTEGRITY_DIR"/log_checksums_*.sha256 2>/dev/null || echo "No checksum files found"
}

# Main script logic
case "$1" in
    "create")
        create_log_checksums
        ;;
    "verify")
        if [ $# -ne 2 ]; then
            echo "Usage: $0 verify <checksum_file>"
            echo "Available files:"
            list_checksum_files
            exit 1
        fi
        verify_log_integrity "$2"
        ;;
    "list")
        list_checksum_files
        ;;
    *)
        echo "Usage: $0 {create|verify|list} [arguments]"
        echo "  create: Create checksums for all log files"
        echo "  verify: Verify log integrity using checksum file"
        echo "  list: List available checksum files"
        exit 1
        ;;
esac
EOF

# Make the script executable
chmod +x scripts/log_integrity.sh
```

2. **Test log integrity protection:**
```bash
# Create initial checksums
./scripts/log_integrity.sh create

# List available checksum files
./scripts/log_integrity.sh list

# Verify integrity
LATEST_CHECKSUM=$(ls -t integrity/log_checksums_*.sha256 | head -1)
./scripts/log_integrity.sh verify "$LATEST_CHECKSUM"

# Test integrity violation detection
echo "TAMPERED DATA" >> logs/financial/transactions.log
./scripts/log_integrity.sh verify "$LATEST_CHECKSUM"
```

### ✅ Checkpoint 2
**Verify your SOX implementation:**
- [ ] SOX directory structure created
- [ ] Financial transaction logging working
- [ ] Access logging functional
- [ ] Segregation of duties checking implemented
- [ ] Log integrity protection system operational
- [ ] Checksums created and verified

---

## Exercise 3: HIPAA Compliance Access Controls

**Time Allocation: 90 minutes**

In this exercise, you'll implement HIPAA (Health Insurance Portability and Accountability Act) compliance through access controls, PHI protection, and comprehensive audit logging.

### Learning Objectives
- Implement HIPAA-compliant access controls for PHI
- Create comprehensive audit logging for healthcare data access
- Set up encryption for PHI protection
- Develop breach detection and notification systems

### Part A: HIPAA Infrastructure Setup

1. **Create HIPAA compliance directory structure:**
```bash
# Create comprehensive HIPAA structure
mkdir -p ~/regulatory_compliance/hipaa/{phi,logs,reports,scripts,policies,encryption}
mkdir -p ~/regulatory_compliance/hipaa/phi/{patient_records,billing,clinical,research}
mkdir -p ~/regulatory_compliance/hipaa/logs/{access,admin,security,audit,breach}
cd ~/regulatory_compliance/hipaa
```

2. **Set up HIPAA user groups and permissions:**
```bash
# Create HIPAA-specific groups (if you have sudo access)
sudo groupadd hipaa-admin 2>/dev/null || echo "Group creation skipped"
sudo groupadd healthcare-provider 2>/dev/null || echo "Group creation skipped"
sudo groupadd billing-staff 2>/dev/null || echo "Group creation skipped"
sudo groupadd security-officer 2>/dev/null || echo "Group creation skipped"

# Set strict permissions for PHI directories
chmod 750 ~/regulatory_compliance/hipaa
chmod 700 ~/regulatory_compliance/hipaa/phi
chmod 755 ~/regulatory_compliance/hipaa/logs
chmod 700 ~/regulatory_compliance/hipaa/encryption
```

3. **Create sample PHI data for testing:**
```bash
# Create sample patient records (encrypted)
mkdir -p phi/patient_records

cat > phi/patient_records/patient_001_temp.txt << 'EOF'
PROTECTED HEALTH INFORMATION
============================
Patient ID: PAT_001
Name: Jane Smith
DOB: 1975-03-22
SSN: XXX-XX-5678
Address: 456 Oak Avenue, Healthcare City, HC 12345
Phone: (555) 123-4567
Email: jane.smith@email.com

Medical Record:
- Diagnosis: Hypertension
- Medications: Lisinopril 10mg daily
- Allergies: Penicillin
- Last Visit: 2024-01-15
- Next Appointment: 2024-02-15

Provider: Dr. Johnson
Facility: Healthcare Center North
EOF

# We'll encrypt this file in the next step
```

### Part B: PHI Access Control and Monitoring

1. **Create PHI access control script:**
```bash
# Create comprehensive PHI access control system
cat > scripts/phi_access_control.sh << 'EOF'
#!/bin/bash
# HIPAA PHI Access Control Script

HIPAA_BASE="$HOME/regulatory_compliance/hipaa"
ACCESS_LOG="$HIPAA_BASE/logs/access/phi_access.log"
AUDIT_LOG="$HIPAA_BASE/logs/audit/hipaa_audit.log"
SECURITY_LOG="$HIPAA_BASE/logs/security/security_events.log"

# Ensure log directories exist
mkdir -p "$(dirname "$ACCESS_LOG")"
mkdir -p "$(dirname "$AUDIT_LOG")"
mkdir -p "$(dirname "$SECURITY_LOG")"

# Function to log PHI access
log_phi_access() {
    local user=$1
    local action=$2
    local phi_resource=$3
    local patient_id=$4
    local purpose=$5
    local location=$6
    
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local session_id="SESS_$(date +%Y%m%d_%H%M%S)_$$"
    local access_id="PHI_$(date +%Y%m%d_%H%M%S)_$$"
    
    # Log to PHI access log
    echo "$timestamp|$access_id|$user|$action|$phi_resource|$patient_id|$purpose|$location|$session_id" >> "$ACCESS_LOG"
    
    # Log to HIPAA audit log
    echo "$timestamp|PHI_ACCESS|User:$user|Action:$action|Resource:$phi_resource|Patient:$patient_id|Purpose:$purpose|Location:$location|Session:$session_id" >> "$AUDIT_LOG"
    
    # Log to system log if available
    logger -t HIPAA_PHI "User: $user accessed PHI for patient $patient_id, Purpose: $purpose, Action: $action" 2>/dev/null || true
    
    echo "PHI access logged: $access_id"
}

# Function to check minimum necessary access
check_minimum_necessary() {
    local user=$1
    local requested_resource=$2
    local purpose=$3
    local patient_id=$4
    
    echo "Checking minimum necessary access for user: $user"
    echo "Resource: $requested_resource, Purpose: $purpose"
    
    # Determine user role (simplified - in real implementation, this would query a directory service)
    local user_role=""
    if groups "$user" 2>/dev/null | grep -q "healthcare-provider"; then
        user_role="healthcare-provider"
    elif groups "$user" 2>/dev/null | grep -q "billing-staff"; then
        user_role="billing-staff"
    elif groups "$user" 2>/dev/null | grep -q "security-officer"; then
        user_role="security-officer"
    else
        user_role="unknown"
    fi
    
    # Apply minimum necessary standard based on role and purpose
    case "$user_role" in
        "healthcare-provider")
            case "$purpose" in
                "treatment"|"diagnosis"|"care_coordination")
                    echo "✓ ACCESS GRANTED: Healthcare provider accessing for treatment purposes"
                    log_phi_access "$user" "ACCESS_GRANTED" "$requested_resource" "$patient_id" "$purpose" "$(hostname)"
                    return 0
                    ;;
                "research")
                    if [[ "$requested_resource" != *"clinical"* ]]; then
                        echo "✓ ACCESS GRANTED: Healthcare provider accessing limited data for research"
                        log_phi_access "$user" "ACCESS_GRANTED_LIMITED" "$requested_resource" "$patient_id" "$purpose" "$(hostname)"
                        return 0
                    fi
                    ;;
            esac
            ;;
        "billing-staff")
            case "$purpose" in
                "payment"|"billing"|"insurance")
                    if [[ "$requested_resource" != *"clinical"* && "$requested_resource" != *"diagnosis"* ]]; then
                        echo "✓ ACCESS GRANTED: Billing staff accessing payment-related information"
                        log_phi_access "$user" "ACCESS_GRANTED" "$requested_resource" "$patient_id" "$purpose" "$(hostname)"
                        return 0
                    fi
                    ;;
            esac
            ;;
        "security-officer")
            case "$purpose" in
                "security"|"audit"|"investigation")
                    echo "✓ ACCESS GRANTED: Security officer accessing for security purposes"
                    log_phi_access "$user" "ACCESS_GRANTED" "$requested_resource" "$patient_id" "$purpose" "$(hostname)"
                    return 0
                    ;;
            esac
            ;;
    esac
    
    echo "✗ ACCESS DENIED: Minimum necessary standard not met"
    echo "User role: $user_role, Purpose: $purpose, Resource: $requested_resource"
    
    # Log the denial
    log_phi_access "$user" "ACCESS_DENIED" "$requested_resource" "$patient_id" "$purpose" "$(hostname)"
    
    # Log security event
    echo "$timestamp|ACCESS_DENIED|User:$user|Role:$user_role|Resource:$requested_resource|Purpose:$purpose|Reason:minimum_necessary_violation" >> "$SECURITY_LOG"
    
    return 1
}

# Function to encrypt PHI
encrypt_phi() {
    local input_file=$1
    local patient_id=$2
    
    if [ ! -f "$input_file" ]; then
        echo "Error: Input file not found: $input_file"
        return 1
    fi
    
    # Generate encryption key if it doesn't exist
    local key_file="$HIPAA_BASE/encryption/phi_key_$patient_id.key"
    if [ ! -f "$key_file" ]; then
        mkdir -p "$(dirname "$key_file")"
        openssl rand -base64 32 > "$key_file"
        chmod 600 "$key_file"
    fi
    
    # Encrypt the file
    local encrypted_file="${input_file%.txt}.enc"
    openssl enc -aes-256-cbc -salt -in "$input_file" -out "$encrypted_file" -pass file:"$key_file"
    
    if [ $? -eq 0 ]; then
        echo "PHI encrypted successfully: $encrypted_file"
        
        # Remove original unencrypted file
        rm "$input_file"
        
        # Log the encryption
        log_phi_access "$(whoami)" "ENCRYPT" "$encrypted_file" "$patient_id" "data_protection" "$(hostname)"
        
        return 0
    else
        echo "Error: PHI encryption failed"
        return 1
    fi
}

# Function to decrypt PHI (with access control)
decrypt_phi() {
    local encrypted_file=$1
    local patient_id=$2
    local purpose=$3
    local user=${4:-$(whoami)}
    
    # Check access permissions first
    if ! check_minimum_necessary "$user" "$encrypted_file" "$purpose" "$patient_id"; then
        echo "Access denied - cannot decrypt PHI"
        return 1
    fi
    
    local key_file="$HIPAA_BASE/encryption/phi_key_$patient_id.key"
    if [ ! -f "$key_file" ]; then
        echo "Error: Encryption key not found for patient $patient_id"
        return 1
    fi
    
    # Decrypt to temporary file
    local temp_file="/tmp/phi_temp_$$_$(date +%s).txt"
    openssl enc -aes-256-cbc -d -in "$encrypted_file" -out "$temp_file" -pass file:"$key_file"
    
    if [ $? -eq 0 ]; then
        echo "PHI decrypted successfully (temporary access)"
        echo "Temporary file: $temp_file"
        echo "WARNING: This file will be automatically deleted in 5 minutes"
        
        # Log the decryption
        log_phi_access "$user" "DECRYPT" "$encrypted_file" "$patient_id" "$purpose" "$(hostname)"
        
        # Schedule automatic deletion of temporary file
        (sleep 300 && rm -f "$temp_file" 2>/dev/null) &
        
        return 0
    else
        echo "Error: PHI decryption failed"
        return 1
    fi
}

# Main script logic
case "$1" in
    "access")
        if [ $# -ne 6 ]; then
            echo "Usage: $0 access <user> <resource> <patient_id> <purpose> <action>"
            exit 1
        fi
        check_minimum_necessary "$2" "$3" "$5" "$4"
        ;;
    "encrypt")
        if [ $# -ne 3 ]; then
            echo "Usage: $0 encrypt <file> <patient_id>"
            exit 1
        fi
        encrypt_phi "$2" "$3"
        ;;
    "decrypt")
        if [ $# -lt 4 ]; then
            echo "Usage: $0 decrypt <encrypted_file> <patient_id> <purpose> [user]"
            exit 1
        fi
        decrypt_phi "$2" "$3" "$4" "$5"
        ;;
    *)
        echo "Usage: $0 {access|encrypt|decrypt} [arguments]"
        echo "  access: $0 access <user> <resource> <patient_id> <purpose> <action>"
        echo "  encrypt: $0 encrypt <file> <patient_id>"
        echo "  decrypt: $0 decrypt <encrypted_file> <patient_id> <purpose> [user]"
        exit 1
        ;;
esac
EOF

# Make the script executable
chmod +x scripts/phi_access_control.sh
```

2. **Test PHI access control system:**
```bash
# Encrypt the sample patient data
./scripts/phi_access_control.sh encrypt phi/patient_records/patient_001_temp.txt PAT_001

# Test access control (this will be denied since we're not in healthcare groups)
./scripts/phi_access_control.sh access "$USER" "patient_001.enc" "PAT_001" "treatment" "READ"

# Test decryption with proper purpose
./scripts/phi_access_control.sh decrypt phi/patient_records/patient_001_temp.enc PAT_001 treatment

# View access logs
echo "=== PHI Access Log ==="
cat logs/access/phi_access.log

echo -e "\n=== HIPAA Audit Log ==="
cat logs/audit/hipaa_audit.log
```

### Part C: HIPAA Breach Detection System

1. **Create breach detection script:**
```bash
# Create HIPAA breach detection system
cat > scripts/breach_detection.sh << 'EOF'
#!/bin/bash
# HIPAA Breach Detection Script

HIPAA_BASE="$HOME/regulatory_compliance/hipaa"
BREACH_LOG="$HIPAA_BASE/logs/breach/breach_detection.log"
ALERT_LOG="$HIPAA_BASE/logs/security/breach_alerts.log"
ACCESS_LOG="$HIPAA_BASE/logs/access/phi_access.log"

# Ensure log directories exist
mkdir -p "$(dirname "$BREACH_LOG")"
mkdir -p "$(dirname "$ALERT_LOG")"

# Function to detect unusual access patterns
detect_unusual_access() {
    echo "$(date): Starting HIPAA breach detection analysis" >> "$BREACH_LOG"
    
    local current_time=$(date +%s)
    local one_hour_ago=$((current_time - 3600))
    local threshold_access_count=10
    local threshold_patient_count=5
    
    echo "Analyzing PHI access patterns for potential breaches..."
    
    # Check for excessive access by single user
    if [ -f "$ACCESS_LOG" ]; then
        # Analyze recent access patterns (last hour)
        awk -F'|' -v start_time="$one_hour_ago" '
        {
            # Convert log timestamp to epoch (simplified)
            gsub(/-/, " ", $1)
            gsub(/:/, " ", $1)
            
            # Count access by user
            user_access[$3]++
            total_access++
            
            # Count unique patients accessed by user
            if (!seen[$3,$5]) {
                user_patients[$3]++
                seen[$3,$5] = 1
            }
        }
        END {
            print "=== BREACH DETECTION ANALYSIS ==="
            print "Analysis time: " strftime("%Y-%m-%d %H:%M:%S")
            print "Total access events analyzed: " total_access
            print ""
            
            for (user in user_access) {
                if (user_access[user] > 10) {
                    print "POTENTIAL_BREACH: User " user " accessed PHI " user_access[user] " times"
                }
                if (user_patients[user] > 5) {
                    print "POTENTIAL_BREACH: User " user " accessed " user_patients[user] " different patients"
                }
            }
        }' "$ACCESS_LOG" >> "$BREACH_LOG"
    fi
    
    # Check for access outside business hours
    local current_hour=$(date +%H)
    local current_day=$(date +%u)  # 1=Monday, 7=Sunday
    
    if [ "$current_hour" -lt 7 ] || [ "$current_hour" -gt 19 ] || [ "$current_day" -eq 6 ] || [ "$current_day" -eq 7 ]; then
        # Check for recent access during off-hours
        local recent_access=$(tail -10 "$ACCESS_LOG" 2>/dev/null | grep "$(date +%Y-%m-%d)" | wc -l)
        if [ "$recent_access" -gt 0 ]; then
            echo "$(date): ALERT - PHI access detected outside business hours" >> "$ALERT_LOG"
            echo "$(date): OFF_HOURS_ACCESS|Events:$recent_access|Hour:$current_hour|Day:$current_day" >> "$BREACH_LOG"
        fi
    fi
    
    # Check for failed access attempts
    local failed_attempts=$(grep "ACCESS_DENIED" "$ACCESS_LOG" 2>/dev/null | grep "$(date +%Y-%m-%d)" | wc -l)
    if [ "$failed_attempts" -gt 5 ]; then
        echo "$(date): ALERT - Multiple failed PHI access attempts: $failed_attempts" >> "$ALERT_LOG"
        echo "$(date): FAILED_ACCESS_PATTERN|Count:$failed_attempts" >> "$BREACH_LOG"
    fi
    
    echo "Breach detection analysis completed"
}

# Function to generate breach notification
generate_breach_notification() {
    local incident_id=$1
    local description=$2
    local affected_patients=$3
    local discovery_date=$4
    local incident_type=$5
    
    local notification_file="$HIPAA_BASE/reports/breach_notification_$incident_id.txt"
    mkdir -p "$(dirname "$notification_file")"
    
    cat > "$notification_file" << EOF
HIPAA BREACH NOTIFICATION REPORT
================================

Incident Information:
- Incident ID: $incident_id
- Discovery Date: $discovery_date
- Report Generated: $(date)
- System: $(hostname)
- Incident Type: $incident_type

Description:
$description

Impact Assessment:
- Number of Affected Patients: $affected_patients
- Types of PHI Involved: [To be determined during investigation]
- Risk Level: [To be assessed]

Required Notifications:
1. Affected Individuals: Within 60 days of discovery
2. Department of Health and Human Services: Within 60 days of discovery
3. Media (if 500+ individuals affected): Without unreasonable delay

Investigation Status:
- Status: INITIATED
- Responsible Officer: HIPAA Security Officer
- Next Review Date: $(date -d '+24 hours' 2>/dev/null || date)

Immediate Actions Taken:
1. Incident documented and logged
2. Preliminary investigation initiated
3. Access controls reviewed
4. Affected systems secured

Next Steps:
1. Complete detailed investigation
2. Assess scope and impact
3. Implement corrective measures
4. Prepare required notifications
5. Update policies and procedures as needed

Contact Information:
- HIPAA Security Officer: security@healthcare.example.com
- Privacy Officer: privacy@healthcare.example.com
- IT Security: itsecurity@healthcare.example.com

EOF

    echo "Breach notification report generated: $notification_file"
    
    # Log the notification generation
    echo "$(date '+%Y-%m-%d %H:%M:%S')|BREACH_NOTIFICATION_GENERATED|$incident_id|$notification_file" >> "$BREACH_LOG"
}

# Function to simulate breach incident for testing
simulate_breach_incident() {
    local incident_type=$1
    local incident_id="BREACH_$(date +%Y%m%d_%H%M%S)"
    
    case "$incident_type" in
        "unauthorized_access")
            generate_breach_notification "$incident_id" "Unauthorized access to patient records detected through access log analysis" "25" "$(date)" "Unauthorized Access"
            ;;
        "data_theft")
            generate_breach_notification "$incident_id" "Potential data theft incident - unusual data access patterns detected" "150" "$(date)" "Data Theft"
            ;;
        "system_breach")
            generate_breach_notification "$incident_id" "System security breach - unauthorized access to PHI database" "500" "$(date)" "System Breach"
            ;;
        *)
            echo "Unknown incident type: $incident_type"
            echo "Available types: unauthorized_access, data_theft, system_breach"
            return 1
            ;;
    esac
}

# Main script logic
case "$1" in
    "detect")
        detect_unusual_access
        ;;
    "notify")
        if [ $# -ne 6 ]; then
            echo "Usage: $0 notify <incident_id> <description> <affected_patients> <discovery_date> <incident_type>"
            exit 1
        fi
        generate_breach_notification "$2" "$3" "$4" "$5" "$6"
        ;;
    "simulate")
        if [ $# -ne 2 ]; then
            echo "Usage: $0 simulate <incident_type>"
            echo "Available types: unauthorized_access, data_theft, system_breach"
            exit 1
        fi
        simulate_breach_incident "$2"
        ;;
    *)
        echo "Usage: $0 {detect|notify|simulate} [arguments]"
        echo "  detect: Run breach detection analysis"
        echo "  notify: Generate breach notification"
        echo "  simulate: Simulate breach incident for testing"
        exit 1
        ;;
esac
EOF

# Make the script executable
chmod +x scripts/breach_detection.sh
```

2. **Test breach detection system:**
```bash
# Run breach detection analysis
./scripts/breach_detection.sh detect

# Simulate a breach incident for testing
./scripts/breach_detection.sh simulate unauthorized_access

# View breach detection logs
echo "=== Breach Detection Log ==="
cat logs/breach/breach_detection.log

echo -e "\n=== Breach Alerts ==="
cat logs/security/breach_alerts.log 2>/dev/null || echo "No alerts generated"

# View generated breach notification
ls -la reports/breach_notification_*.txt 2>/dev/null && cat reports/breach_notification_*.txt | head -30
```

### ✅ Checkpoint 3
**Verify your HIPAA implementation:**
- [ ] HIPAA directory structure created
- [ ] PHI access control system working
- [ ] Minimum necessary access checking functional
- [ ] PHI encryption and decryption operational
- [ ] Breach detection system implemented
- [ ] Breach notification generation working

---

## Exercise 4: PCI DSS Security Monitoring

**Time Allocation: 75 minutes**

In this final exercise, you'll implement PCI DSS (Payment Card Industry Data Security Standard) compliance through network security monitoring, vulnerability scanning, and intrusion detection.

### Learning Objectives
- Implement PCI DSS network security monitoring
- Create vulnerability scanning and assessment systems
- Set up intrusion detection and prevention
- Develop automated PCI DSS compliance checking

### Part A: PCI DSS Infrastructure Setup

1. **Create PCI DSS compliance directory structure:**
```bash
# Create comprehensive PCI DSS structure
mkdir -p ~/regulatory_compliance/pci_dss/{network,logs,reports,scripts,scans,policies}
mkdir -p ~/regulatory_compliance/pci_dss/network/{cardholder_data,dmz,internal,monitoring}
mkdir -p ~/regulatory_compliance/pci_dss/logs/{firewall,ids,access,vulnerability,compliance}
cd ~/regulatory_compliance/pci_dss
```

2. **Set up network security monitoring:**
```bash
# Configure firewall logging (if UFW is available)
if command -v ufw >/dev/null 2>&1; then
    echo "UFW firewall available"
    echo "To enable PCI DSS firewall logging, run:"
    echo "sudo ufw --force enable"
    echo "sudo ufw logging on"
else
    echo "UFW not available - using custom logging"
fi

# Set directory permissions
chmod 750 ~/regulatory_compliance/pci_dss
chmod 700 ~/regulatory_compliance/pci_dss/network/cardholder_data
chmod 755 ~/regulatory_compliance/pci_dss/logs
```

### Part B: Vulnerability Scanning Implementation

1. **Create vulnerability scanning script:**
```bash
# Create comprehensive vulnerability scanning system
cat > scripts/vulnerability_scanner.sh << 'EOF'
#!/bin/bash
# PCI DSS Vulnerability Scanner Script

PCI_BASE="$HOME/regulatory_compliance/pci_dss"
SCAN_LOG="$PCI_BASE/logs/vulnerability/scan_results.log"
REPORT_DIR="$PCI_BASE/reports"
COMPLIANCE_LOG="$PCI_BASE/logs/compliance/pci_compliance.log"

# Ensure directories exist
mkdir -p "$(dirname "$SCAN_LOG")"
mkdir -p "$REPORT_DIR"
mkdir -p "$(dirname "$COMPLIANCE_LOG")"

# Function to perform network vulnerability scan
perform_vulnerability_scan() {
    local target=$1
    local scan_type=$2
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local scan_report="$REPORT_DIR/vuln_scan_$timestamp.txt"
    local scan_id="SCAN_$timestamp"
    
    echo "$(date): Starting PCI DSS vulnerability scan" >> "$SCAN_LOG"
    echo "Scan ID: $scan_id, Target: $target, Type: $scan_type" >> "$SCAN_LOG"
    
    echo "=== PCI DSS VULNERABILITY SCAN REPORT ===" > "$scan_report"
    echo "Scan ID: $scan_id" >> "$scan_report"
    echo "Target: $target" >> "$scan_report"
    echo "Scan Type: $scan_type" >> "$scan_report"
    echo "Date: $(date)" >> "$scan_report"
    echo "Scanner: $(hostname)" >> "$scan_report"
    echo "" >> "$scan_report"
    
    case "$scan_type" in
        "basic")
            echo "Performing basic network scan..."
            if command -v nmap >/dev/null 2>&1; then
                echo "=== BASIC NETWORK SCAN ===" >> "$scan_report"
                nmap -sV "$target" >> "$scan_report" 2>&1
            else
                echo "nmap not available - performing basic connectivity check" >> "$scan_report"
                ping -c 3 "$target" >> "$scan_report" 2>&1
            fi
            ;;
        "comprehensive")
            echo "Performing comprehensive security scan..."
            if command -v nmap >/dev/null 2>&1; then
                echo "=== COMPREHENSIVE SECURITY SCAN ===" >> "$scan_report"
                nmap -sS -sV -sC -A "$target" >> "$scan_report" 2>&1
            else
                echo "nmap not available - performing alternative checks" >> "$scan_report"
                netstat -tuln >> "$scan_report" 2>&1
            fi
            ;;
        "pci_specific")
            echo "Performing PCI DSS specific vulnerability checks..."
            echo "=== PCI DSS SPECIFIC CHECKS ===" >> "$scan_report"
            
            # Check for common PCI DSS vulnerabilities
            if command -v nmap >/dev/null 2>&1; then
                nmap --script vuln "$target" >> "$scan_report" 2>&1
            fi
            
            # Check local system for PCI DSS compliance issues
            echo "" >> "$scan_report"
            echo "=== LOCAL SYSTEM PCI DSS CHECKS ===" >> "$scan_report"
            
            # Check for unencrypted services
            echo "Checking for unencrypted services..." >> "$scan_report"
            netstat -tuln | grep -E ":21|:23|:80[^0-9]|:143|:110" >> "$scan_report" 2>&1 || echo "No unencrypted services detected" >> "$scan_report"
            
            # Check for default passwords (simplified check)
            echo "" >> "$scan_report"
            echo "Checking for potential default configurations..." >> "$scan_report"
            ps aux | grep -E "mysql|apache|nginx" | grep -v grep >> "$scan_report" 2>&1 || echo "No common services with potential default configs detected" >> "$scan_report"
            ;;
    esac
    
    # Analyze scan results for PCI DSS compliance
    analyze_pci_vulnerabilities "$scan_report"
    
    echo "$(date): Vulnerability scan completed: $scan_report" >> "$SCAN_LOG"
    echo "Vulnerability scan completed: $scan_report"
}

# Function to analyze vulnerabilities for PCI DSS compliance
analyze_pci_vulnerabilities() {
    local scan_file=$1
    local analysis_file="${scan_file%.txt}_analysis.txt"
    
    echo "=== PCI DSS VULNERABILITY ANALYSIS ===" > "$analysis_file"
    echo "Analysis Date: $(date)" >> "$analysis_file"
    echo "Source Scan: $(basename "$scan_file")" >> "$analysis_file"
    echo "" >> "$analysis_file"
    
    local critical_count=0
    local high_count=0
    local medium_count=0
    
    # Check for critical PCI DSS issues
    echo "=== CRITICAL PCI DSS ISSUES ===" >> "$analysis_file"
    
    # Check for unencrypted services (PCI DSS Requirement 4.1)
    if grep -qi "telnet\|ftp[^s]\|http[^s]" "$scan_file"; then
        echo "CRITICAL: Unencrypted services detected (PCI DSS Req 4.1)" >> "$analysis_file"
        critical_count=$((critical_count + 1))
    fi
    
    # Check for default passwords (PCI DSS Requirement 2.1)
    if grep -qi "default\|admin.*admin\|password.*password" "$scan_file"; then
        echo "CRITICAL: Default credentials may be present (PCI DSS Req 2.1)" >> "$analysis_file"
        critical_count=$((critical_count + 1))
    fi
    
    # Check for unnecessary services (PCI DSS Requirement 2.2)
    if grep -qi "finger\|echo\|discard\|chargen" "$scan_file"; then
        echo "HIGH: Unnecessary services detected (PCI DSS Req 2.2)" >> "$analysis_file"
        high_count=$((high_count + 1))
    fi
    
    # Check for weak SSL/TLS (PCI DSS Requirement 4.1)
    if grep -qi "sslv2\|sslv3\|weak.*cipher" "$scan_file"; then
        echo "HIGH: Weak SSL/TLS configuration detected (PCI DSS Req 4.1)" >> "$analysis_file"
        high_count=$((high_count + 1))
    fi
    
    # Check for open ports that shouldn't be (PCI DSS Requirement 1.1)
    if grep -qi "1433\|3389\|5432" "$scan_file"; then
        echo "MEDIUM: Database or remote access ports detected (PCI DSS Req 1.1)" >> "$analysis_file"
        medium_count=$((medium_count + 1))
    fi
    
    echo "" >> "$analysis_file"
    echo "=== VULNERABILITY SUMMARY ===" >> "$analysis_file"
    echo "Critical Issues: $critical_count" >> "$analysis_file"
    echo "High Issues: $high_count" >> "$analysis_file"
    echo "Medium Issues: $medium_count" >> "$analysis_file"
    
    # Determine overall compliance status
    if [ "$critical_count" -gt 0 ]; then
        echo "Overall Status: NON-COMPLIANT (Critical issues found)" >> "$analysis_file"
        compliance_status="NON-COMPLIANT"
    elif [ "$high_count" -gt 3 ]; then
        echo "Overall Status: AT RISK (Multiple high-risk issues)" >> "$analysis_file"
        compliance_status="AT_RISK"
    else
        echo "Overall Status: COMPLIANT (No critical issues detected)" >> "$analysis_file"
        compliance_status="COMPLIANT"
    fi
    
    # Log compliance status
    echo "$(date '+%Y-%m-%d %H:%M:%S')|VULNERABILITY_ANALYSIS|Status:$compliance_status|Critical:$critical_count|High:$high_count|Medium:$medium_count" >> "$COMPLIANCE_LOG"
    
    echo "Vulnerability analysis completed: $analysis_file"
}

# Function to generate PCI DSS compliance report
generate_compliance_report() {
    local report_file="$REPORT_DIR/pci_compliance_report_$(date +%Y%m%d_%H%M%S).txt"
    
    echo "=== PCI DSS COMPLIANCE REPORT ===" > "$report_file"
    echo "Generated: $(date)" >> "$report_file"
    echo "System: $(hostname)" >> "$report_file"
    echo "" >> "$report_file"
    
    # Network security status
    echo "=== NETWORK SECURITY STATUS ===" >> "$report_file"
    if command -v ufw >/dev/null 2>&1; then
        echo "Firewall Status:" >> "$report_file"
        ufw status 2>/dev/null >> "$report_file" || echo "Firewall status unavailable" >> "$report_file"
    else
        echo "UFW firewall not available" >> "$report_file"
    fi
    echo "" >> "$report_file"
    
    # Active network services
    echo "=== ACTIVE NETWORK SERVICES ===" >> "$report_file"
    netstat -tuln >> "$report_file" 2>&1
    echo "" >> "$report_file"
    
    # Recent vulnerability scans
    echo "=== RECENT VULNERABILITY SCANS ===" >> "$report_file"
    local recent_scans=$(find "$REPORT_DIR" -name "vuln_scan_*.txt" -mtime -7 2>/dev/null | wc -l)
    echo "Vulnerability scans in last 7 days: $recent_scans" >> "$report_file"
    
    if [ "$recent_scans" -gt 0 ]; then
        echo "Latest scan results:" >> "$report_file"
        local latest_scan=$(ls -t "$REPORT_DIR"/vuln_scan_*.txt 2>/dev/null | head -1)
        if [ -n "$latest_scan" ]; then
            tail -20 "$latest_scan" >> "$report_file"
        fi
    fi
    echo "" >> "$report_file"
    
    # System updates
    echo "=== SECURITY UPDATES ===" >> "$report_file"
    if command -v apt >/dev/null 2>&1; then
        local security_updates=$(apt list --upgradable 2>/dev/null | grep -i security | wc -l)
        echo "Available security updates: $security_updates" >> "$report_file"
    else
        echo "Package manager not available for update check" >> "$report_file"
    fi
    
    echo "PCI DSS compliance report generated: $report_file"
}

# Main script logic
case "$1" in
    "scan")
        if [ $# -lt 2 ]; then
            echo "Usage: $0 scan <target> [scan_type]"
            echo "Scan types: basic, comprehensive, pci_specific"
            exit 1
        fi
        scan_type=${3:-basic}
        perform_vulnerability_scan "$2" "$scan_type"
        ;;
    "analyze")
        if [ $# -ne 2 ]; then
            echo "Usage: $0 analyze <scan_file>"
            exit 1
        fi
        analyze_pci_vulnerabilities "$2"
        ;;
    "report")
        generate_compliance_report
        ;;
    *)
        echo "Usage: $0 {scan|analyze|report} [arguments]"
        echo "  scan: Perform vulnerability scan"
        echo "  analyze: Analyze scan results for PCI DSS compliance"
        echo "  report: Generate PCI DSS compliance report"
        exit 1
        ;;
esac
EOF

# Make the script executable
chmod +x scripts/vulnerability_scanner.sh
```

2. **Test vulnerability scanning:**
```bash
# Perform basic vulnerability scan on localhost
./scripts/vulnerability_scanner.sh scan localhost basic

# Perform PCI DSS specific scan
./scripts/vulnerability_scanner.sh scan localhost pci_specific

# Generate compliance report
./scripts/vulnerability_scanner.sh report

# View scan results
echo "=== Latest Vulnerability Scan ==="
ls -t reports/vuln_scan_*.txt | head -1 | xargs cat | head -30

echo -e "\n=== Latest Analysis ==="
ls -t reports/vuln_scan_*_analysis.txt | head -1 | xargs cat | head -20
```

### Part C: Intrusion Detection System

1. **Create intrusion detection script:**
```bash
# Create PCI DSS intrusion detection system
cat > scripts/intrusion_detection.sh << 'EOF'
#!/bin/bash
# PCI DSS Intrusion Detection Script

PCI_BASE="$HOME/regulatory_compliance/pci_dss"
IDS_LOG="$PCI_BASE/logs/ids/intrusion_detection.log"
ALERT_LOG="$PCI_BASE/logs/ids/security_alerts.log"
FIREWALL_LOG="$PCI_BASE/logs/firewall/firewall_events.log"

# Ensure log directories exist
mkdir -p "$(dirname "$IDS_LOG")"
mkdir -p "$(dirname "$ALERT_LOG")"
mkdir -p "$(dirname "$FIREWALL_LOG")"

# Function to monitor authentication events
monitor_authentication() {
    echo "$(date): Starting PCI DSS authentication monitoring" >> "$IDS_LOG"
    
    # Monitor authentication logs for suspicious activity
    if [ -f "/var/log/auth.log" ]; then
        # Check for failed login attempts
        local failed_logins=$(grep "Failed password" /var/log/auth.log | grep "$(date +%b\ %d)" | wc -l)
        
        if [ "$failed_logins" -gt 5 ]; then
            echo "$(date): ALERT - Multiple failed login attempts detected: $failed_logins" >> "$ALERT_LOG"
            
            # Extract IP addresses with failed attempts
            grep "Failed password" /var/log/auth.log | grep "$(date +%b\ %d)" | \
            grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' | \
            sort | uniq -c | sort -nr | head -5 >> "$ALERT_LOG"
        fi
        
        # Check for successful logins after failed attempts (potential brute force success)
        local recent_success=$(grep "Accepted password" /var/log/auth.log | grep "$(date +%b\ %d)" | wc -l)
        if [ "$failed_logins" -gt 10 ] && [ "$recent_success" -gt 0 ]; then
            echo "$(date): CRITICAL - Successful login after multiple failures detected" >> "$ALERT_LOG"
        fi
    else
        echo "$(date): Authentication log not accessible" >> "$IDS_LOG"
    fi
}

# Function to monitor network connections
monitor_network() {
    echo "$(date): Starting network connection monitoring" >> "$IDS_LOG"
    
    # Check for suspicious network connections
    local suspicious_ports="1433 3389 5432 23 21"
    
    for port in $suspicious_ports; do
        if netstat -tuln | grep -q ":$port "; then
            echo "$(date): WARNING - Suspicious service detected on port $port" >> "$ALERT_LOG"
            netstat -tuln | grep ":$port " >> "$ALERT_LOG"
        fi
    done
    
    # Check for unusual outbound connections
    local outbound_connections=$(netstat -tun | grep ESTABLISHED | wc -l)
    if [ "$outbound_connections" -gt 50 ]; then
        echo "$(date): WARNING - High number of outbound connections: $outbound_connections" >> "$ALERT_LOG"
    fi
    
    # Log current network status
    echo "$(date): Active connections: $outbound_connections" >> "$IDS_LOG"
}

# Function to monitor file system changes
monitor_filesystem() {
    echo "$(date): Starting file system monitoring" >> "$IDS_LOG"
    
    # Check for changes to critical system files
    local critical_files="/etc/passwd /etc/shadow /etc/group /etc/sudoers"
    
    for file in $critical_files; do
        if [ -f "$file" ]; then
            local file_hash=$(sha256sum "$file" | cut -d' ' -f1)
            local hash_file="$PCI_BASE/logs/ids/$(basename "$file").hash"
            
            if [ -f "$hash_file" ]; then
                local stored_hash=$(cat "$hash_file")
                if [ "$file_hash" != "$stored_hash" ]; then
                    echo "$(date): CRITICAL - Critical file modified: $file" >> "$ALERT_LOG"
                    echo "Previous hash: $stored_hash" >> "$ALERT_LOG"
                    echo "Current hash: $file_hash" >> "$ALERT_LOG"
                fi
            fi
            
            # Update stored hash
            echo "$file_hash" > "$hash_file"
        fi
    done
}

# Function to check for malware indicators
check_malware_indicators() {
    echo "$(date): Starting malware indicator check" >> "$IDS_LOG"
    
    # Check for suspicious processes
    local suspicious_processes="nc netcat ncat socat"
    
    for process in $suspicious_processes; do
        if pgrep "$process" >/dev/null 2>&1; then
            echo "$(date): WARNING - Suspicious process detected: $process" >> "$ALERT_LOG"
            ps aux | grep "$process" | grep -v grep >> "$ALERT_LOG"
        fi
    done
    
    # Check for unusual CPU usage
    local cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
    if [ "${cpu_usage%.*}" -gt 80 ]; then
        echo "$(date): WARNING - High CPU usage detected: ${cpu_usage}%" >> "$ALERT_LOG"
        top -bn1 | head -15 >> "$ALERT_LOG"
    fi
}

# Function to generate security summary
generate_security_summary() {
    local summary_file="$PCI_BASE/reports/security_summary_$(date +%Y%m%d_%H%M%S).txt"
    
    echo "=== PCI DSS SECURITY MONITORING SUMMARY ===" > "$summary_file"
    echo "Generated: $(date)" >> "$summary_file"
    echo "System: $(hostname)" >> "$summary_file"
    echo "" >> "$summary_file"
    
    # Authentication summary
    echo "=== AUTHENTICATION EVENTS (Last 24 hours) ===" >> "$summary_file"
    if [ -f "/var/log/auth.log" ]; then
        local failed_count=$(grep "Failed password" /var/log/auth.log | grep "$(date +%b\ %d)" | wc -l)
        local success_count=$(grep "Accepted password" /var/log/auth.log | grep "$(date +%b\ %d)" | wc -l)
        echo "Failed login attempts: $failed_count" >> "$summary_file"
        echo "Successful logins: $success_count" >> "$summary_file"
    else
        echo "Authentication log not accessible" >> "$summary_file"
    fi
    echo "" >> "$summary_file"
    
    # Network summary
    echo "=== NETWORK STATUS ===" >> "$summary_file"
    echo "Active connections: $(netstat -tun | grep ESTABLISHED | wc -l)" >> "$summary_file"
    echo "Listening services: $(netstat -tuln | grep LISTEN | wc -l)" >> "$summary_file"
    echo "" >> "$summary_file"
    
    # Security alerts summary
    echo "=== SECURITY ALERTS (Last 24 hours) ===" >> "$summary_file"
    if [ -f "$ALERT_LOG" ]; then
        local alert_count=$(grep "$(date +%Y-%m-%d)" "$ALERT_LOG" | wc -l)
        echo "Total alerts: $alert_count" >> "$summary_file"
        
        if [ "$alert_count" -gt 0 ]; then
            echo "Recent alerts:" >> "$summary_file"
            grep "$(date +%Y-%m-%d)" "$ALERT_LOG" | tail -10 >> "$summary_file"
        fi
    else
        echo "No alerts generated" >> "$summary_file"
    fi
    
    echo "Security summary generated: $summary_file"
}

# Function to run continuous monitoring
run_continuous_monitoring() {
    echo "Starting continuous PCI DSS security monitoring..."
    echo "Press Ctrl+C to stop"
    
    while true; do
        monitor_authentication
        monitor_network
        monitor_filesystem
        check_malware_indicators
        
        echo "$(date): Monitoring cycle completed" >> "$IDS_LOG"
        sleep 60  # Wait 1 minute between checks
    done
}

# Main script logic
case "$1" in
    "auth")
        monitor_authentication
        ;;
    "network")
        monitor_network
        ;;
    "filesystem")
        monitor_filesystem
        ;;
    "malware")
        check_malware_indicators
        ;;
    "summary")
        generate_security_summary
        ;;
    "continuous")
        run_continuous_monitoring
        ;;
    "all")
        monitor_authentication
        monitor_network
        monitor_filesystem
        check_malware_indicators
        generate_security_summary
        ;;
    *)
        echo "Usage: $0 {auth|network|filesystem|malware|summary|continuous|all}"
        echo "  auth: Monitor authentication events"
        echo "  network: Monitor network connections"
        echo "  filesystem: Monitor file system changes"
        echo "  malware: Check for malware indicators"
        echo "  summary: Generate security summary report"
        echo "  continuous: Run continuous monitoring (Ctrl+C to stop)"
        echo "  all: Run all monitoring checks once"
        exit 1
        ;;
esac
EOF

# Make the script executable
chmod +x scripts/intrusion_detection.sh
```

2. **Test intrusion detection system:**
```bash
# Run all monitoring checks
./scripts/intrusion_detection.sh all

# Generate security summary
./scripts/intrusion_detection.sh summary

# View security alerts
echo "=== Security Alerts ==="
cat logs/ids/security_alerts.log 2>/dev/null || echo "No alerts generated"

echo -e "\n=== IDS Log ==="
cat logs/ids/intrusion_detection.log | tail -10

echo -e "\n=== Latest Security Summary ==="
ls -t reports/security_summary_*.txt | head -1 | xargs cat | head -20
```

### ✅ Final Checkpoint
**Verify your complete regulatory compliance system:**
- [ ] PCI DSS directory structure created
- [ ] Vulnerability scanning system operational
- [ ] Intrusion detection system functional
- [ ] Security monitoring and alerting working
- [ ] Compliance reporting generated
- [ ] All regulatory frameworks integrated

---

## Lab Completion and Integration

### Unified Regulatory Compliance Dashboard

Now that you've implemented all four regulatory frameworks, let's create a unified dashboard to monitor overall compliance status.

```bash
# Create unified compliance dashboard
cat > ~/regulatory_compliance/unified_dashboard.sh << 'EOF'
#!/bin/bash
# Unified Regulatory Compliance Dashboard

COMPLIANCE_BASE="$HOME/regulatory_compliance"

clear
echo "=========================================="
echo "  ICDFA Regulatory Compliance Dashboard"
echo "=========================================="
echo "Generated: $(date)"
echo "System: $(hostname)"
echo ""

# GDPR Status
echo "🇪🇺 GDPR COMPLIANCE STATUS:"
if [ -d "$COMPLIANCE_BASE/gdpr" ]; then
    encrypted_files=$(find "$COMPLIANCE_BASE/gdpr/data/encrypted" -name "*.enc" 2>/dev/null | wc -l)
    access_logs=$(find "$COMPLIANCE_BASE/gdpr/logs" -name "*.log" -mtime -1 2>/dev/null | wc -l)
    echo "   ├─ Encrypted PHI Files: $encrypted_files"
    echo "   ├─ Recent Access Logs: $access_logs"
    echo "   └─ Status: $([ $encrypted_files -gt 0 ] && echo "✅ Active" || echo "⚠️  Setup Needed")"
else
    echo "   └─ Status: ❌ Not Configured"
fi
echo ""

# SOX Status
echo "📊 SOX COMPLIANCE STATUS:"
if [ -d "$COMPLIANCE_BASE/sox" ]; then
    transaction_logs=$(find "$COMPLIANCE_BASE/sox/logs/financial" -name "*.log" 2>/dev/null | wc -l)
    integrity_checks=$(find "$COMPLIANCE_BASE/sox/integrity" -name "*.sha256" 2>/dev/null | wc -l)
    echo "   ├─ Transaction Logs: $transaction_logs"
    echo "   ├─ Integrity Checks: $integrity_checks"
    echo "   └─ Status: $([ $transaction_logs -gt 0 ] && echo "✅ Active" || echo "⚠️  Setup Needed")"
else
    echo "   └─ Status: ❌ Not Configured"
fi
echo ""

# HIPAA Status
echo "🏥 HIPAA COMPLIANCE STATUS:"
if [ -d "$COMPLIANCE_BASE/hipaa" ]; then
    phi_access_logs=$(find "$COMPLIANCE_BASE/hipaa/logs/access" -name "*.log" 2>/dev/null | wc -l)
    breach_reports=$(find "$COMPLIANCE_BASE/hipaa/reports" -name "breach_notification_*.txt" 2>/dev/null | wc -l)
    echo "   ├─ PHI Access Logs: $phi_access_logs"
    echo "   ├─ Breach Reports: $breach_reports"
    echo "   └─ Status: $([ $phi_access_logs -gt 0 ] && echo "✅ Active" || echo "⚠️  Setup Needed")"
else
    echo "   └─ Status: ❌ Not Configured"
fi
echo ""

# PCI DSS Status
echo "💳 PCI DSS COMPLIANCE STATUS:"
if [ -d "$COMPLIANCE_BASE/pci_dss" ]; then
    vuln_scans=$(find "$COMPLIANCE_BASE/pci_dss/reports" -name "vuln_scan_*.txt" -mtime -7 2>/dev/null | wc -l)
    security_alerts=$(find "$COMPLIANCE_BASE/pci_dss/logs/ids" -name "*alert*.log" -mtime -1 2>/dev/null | wc -l)
    echo "   ├─ Weekly Vulnerability Scans: $vuln_scans"
    echo "   ├─ Recent Security Alerts: $security_alerts"
    echo "   └─ Status: $([ $vuln_scans -gt 0 ] && echo "✅ Active" || echo "⚠️  Setup Needed")"
else
    echo "   └─ Status: ❌ Not Configured"
fi
echo ""

# System Health
echo "🖥️  SYSTEM HEALTH:"
load_avg=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | sed 's/,//')
disk_usage=$(df -h ~ | awk 'NR==2 {print $5}')
echo "   ├─ Load Average: $load_avg"
echo "   ├─ Disk Usage: $disk_usage"
echo "   └─ Compliance Files: $(find "$COMPLIANCE_BASE" -type f | wc -l)"
echo ""

echo "📋 QUICK ACTIONS:"
echo "   1. View GDPR logs: cat $COMPLIANCE_BASE/gdpr/logs/access/*.log"
echo "   2. Check SOX integrity: $COMPLIANCE_BASE/sox/scripts/log_integrity.sh list"
echo "   3. Run HIPAA breach detection: $COMPLIANCE_BASE/hipaa/scripts/breach_detection.sh detect"
echo "   4. Perform PCI DSS scan: $COMPLIANCE_BASE/pci_dss/scripts/vulnerability_scanner.sh scan localhost"
echo ""
echo "=========================================="
EOF

# Make the dashboard executable
chmod +x ~/regulatory_compliance/unified_dashboard.sh

# Run the unified dashboard
~/regulatory_compliance/unified_dashboard.sh
```

### Lab Summary and Reflection

Congratulations! You have successfully completed the Week 2 Linux Lab on Regulatory Environment and Standards. You have implemented:

1. **GDPR Compliance System** with data encryption, access controls, and data subject rights
2. **SOX Compliance Framework** with audit trails, segregation of duties, and log integrity
3. **HIPAA Compliance Controls** with PHI protection, access monitoring, and breach detection
4. **PCI DSS Security Monitoring** with vulnerability scanning and intrusion detection

### Key Skills Developed
- Regulatory compliance implementation using Linux tools
- Data encryption and protection mechanisms
- Comprehensive audit logging and monitoring
- Access control and segregation of duties
- Breach detection and incident response
- Automated compliance reporting and dashboards

### Reflection Questions

1. **How do different regulatory frameworks complement each other in a comprehensive compliance program?**
   
   _Your answer:_
   ________________________________________________

2. **What are the challenges of implementing multiple regulatory requirements simultaneously?**
   
   _Your answer:_
   ________________________________________________

3. **How can automation improve regulatory compliance monitoring and reduce human error?**
   
   _Your answer:_
   ________________________________________________

4. **What role does Linux play in enterprise regulatory compliance, and what are its advantages?**
   
   _Your answer:_
   ________________________________________________

### Next Steps

To prepare for Week 3's lab on Risk Management Fundamentals:
1. Review risk assessment methodologies
2. Research Linux tools for risk monitoring
3. Practice the regulatory compliance scripts you created
4. Prepare questions about risk quantification and management

---

**Lab Completed Successfully! 🎉**

*You have successfully implemented comprehensive regulatory compliance systems using Linux tools and demonstrated practical understanding of GDPR, SOX, HIPAA, and PCI DSS requirements through hands-on technical implementation.*

