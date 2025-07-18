# Week 2 Linux Lab: Regulatory Environment and Standards
## Instructor Guide

**International Cybersecurity and Digital Forensics Academy (ICDFA)**  
**Course: GRC101 - Introduction to Governance, Risk, and Compliance**  
**Lab Duration: 3 hours**  
**Difficulty Level: Intermediate**

---

## Lab Overview

This advanced lab focuses on implementing regulatory compliance monitoring and reporting systems using Linux tools. Students will learn to create automated compliance verification systems for major regulatory frameworks including GDPR, SOX, HIPAA, and PCI DSS. The lab emphasizes practical implementation of regulatory requirements through Linux-based monitoring, logging, and reporting mechanisms.

### Learning Objectives

By the end of this lab, students will be able to:
1. Implement GDPR compliance monitoring using Linux privacy tools
2. Create SOX-compliant audit trails and financial data protection systems
3. Set up HIPAA-compliant access controls and audit logging
4. Implement PCI DSS security monitoring and vulnerability scanning
5. Generate automated regulatory compliance reports
6. Understand how Linux security features support regulatory compliance

### Prerequisites

- Completion of Week 1 Linux Lab
- Understanding of major regulatory frameworks
- Intermediate Linux command-line skills
- Basic knowledge of system logging and monitoring
- Familiarity with network security concepts

---

## Lab Environment Setup

### Required Software and Tools
- Linux OS (Ubuntu 22.04 LTS recommended)
- OpenSSL for encryption and certificate management
- Apache/Nginx for web server compliance testing
- MySQL/PostgreSQL for database security compliance
- Fail2ban for intrusion detection
- Lynis for security auditing
- ClamAV for malware scanning
- Log analysis tools (rsyslog, logrotate)

### Pre-Lab Preparation
1. Ensure all regulatory compliance tools are installed
2. Create test databases with sample sensitive data
3. Set up web server environments for compliance testing
4. Prepare regulatory compliance templates and checklists
5. Configure centralized logging infrastructure

### Installation Commands
```bash
# Update system and install base tools
sudo apt update && sudo apt upgrade -y

# Install web servers and databases
sudo apt install -y apache2 nginx mysql-server postgresql

# Install security and compliance tools
sudo apt install -y lynis clamav clamav-daemon fail2ban
sudo apt install -y openssl ca-certificates
sudo apt install -y rsyslog logrotate

# Install monitoring and analysis tools
sudo apt install -y htop iotop netstat-nat nmap
sudo apt install -y jq xmlstarlet csvkit

# Install encryption and privacy tools
sudo apt install -y gnupg2 cryptsetup ecryptfs-utils
```

---

## Exercise 1: GDPR Compliance Implementation (60 minutes)

### Instructor Notes
This exercise teaches students to implement GDPR (General Data Protection Regulation) compliance using Linux tools. Focus on data protection, privacy controls, access logging, and breach detection mechanisms. Emphasize the technical implementation of GDPR principles through Linux security features.

### Learning Outcomes
- Implement data encryption for personal data protection
- Create access control systems for data subject rights
- Set up audit logging for data processing activities
- Develop breach detection and notification systems
- Generate GDPR compliance reports

### Setup Instructions
1. Create sample personal data sets for testing
2. Set up encryption systems for data protection
3. Configure access control mechanisms
4. Implement audit logging for data access
5. Prepare GDPR compliance templates

### Step-by-Step Walkthrough

#### Part A: Data Protection and Encryption Setup
```bash
# Create GDPR compliance directory structure
sudo mkdir -p /opt/gdpr/{data,logs,reports,scripts,policies}
sudo mkdir -p /opt/gdpr/data/{encrypted,processed,archived}

# Set up proper permissions
sudo chown -R root:gdpr-admin /opt/gdpr
sudo chmod -R 750 /opt/gdpr

# Create GDPR admin group
sudo groupadd gdpr-admin
sudo groupadd data-processor
sudo groupadd data-subject
```

#### Part B: Personal Data Encryption Implementation
Students will implement encryption systems for personal data protection as required by GDPR.

```bash
#!/bin/bash
# GDPR Data Encryption Script
# File: /opt/gdpr/scripts/encrypt_personal_data.sh

GDPR_BASE="/opt/gdpr"
ENCRYPTION_KEY="$GDPR_BASE/keys/gdpr_master.key"

# Generate encryption key if it doesn't exist
if [ ! -f "$ENCRYPTION_KEY" ]; then
    mkdir -p "$GDPR_BASE/keys"
    openssl rand -base64 32 > "$ENCRYPTION_KEY"
    chmod 600 "$ENCRYPTION_KEY"
    echo "Master encryption key generated"
fi

# Function to encrypt personal data
encrypt_personal_data() {
    local input_file=$1
    local output_file=$2
    
    if [ -f "$input_file" ]; then
        openssl enc -aes-256-cbc -salt -in "$input_file" -out "$output_file" -pass file:"$ENCRYPTION_KEY"
        echo "Encrypted: $input_file -> $output_file"
        
        # Log the encryption activity
        echo "$(date): Encrypted personal data file $input_file" >> "$GDPR_BASE/logs/encryption.log"
    else
        echo "Error: Input file $input_file not found"
    fi
}
```

#### Part C: Data Subject Rights Implementation
```bash
#!/bin/bash
# Data Subject Rights Management Script
# File: /opt/gdpr/scripts/data_subject_rights.sh

GDPR_BASE="/opt/gdpr"
RIGHTS_LOG="$GDPR_BASE/logs/data_subject_rights.log"

# Function to handle data access requests
handle_access_request() {
    local subject_id=$1
    local requester=$2
    
    echo "$(date): Data access request for subject $subject_id by $requester" >> "$RIGHTS_LOG"
    
    # Search for personal data
    find "$GDPR_BASE/data" -name "*$subject_id*" -type f > "$GDPR_BASE/reports/access_request_$subject_id.txt"
    
    echo "Access request processed for subject: $subject_id"
}

# Function to handle data deletion requests (Right to be Forgotten)
handle_deletion_request() {
    local subject_id=$1
    local requester=$2
    
    echo "$(date): Data deletion request for subject $subject_id by $requester" >> "$RIGHTS_LOG"
    
    # Create backup before deletion
    mkdir -p "$GDPR_BASE/data/deletion_backups"
    find "$GDPR_BASE/data" -name "*$subject_id*" -type f -exec cp {} "$GDPR_BASE/data/deletion_backups/" \;
    
    # Remove personal data
    find "$GDPR_BASE/data" -name "*$subject_id*" -type f -delete
    
    echo "$(date): Data deleted for subject $subject_id" >> "$RIGHTS_LOG"
    echo "Deletion request processed for subject: $subject_id"
}
```

### Assessment Criteria
- Proper implementation of data encryption
- Correct access control configuration
- Effective audit logging mechanisms
- Quality of data subject rights implementation
- Understanding of GDPR technical requirements

### Common Issues and Solutions
1. **Encryption Key Management**: Ensure proper key storage and access controls
2. **Access Control Complexity**: Verify group memberships and permissions
3. **Audit Log Integrity**: Implement log protection and rotation
4. **Performance Impact**: Monitor system performance with encryption enabled

---

## Exercise 2: SOX Compliance Audit Trail Implementation (75 minutes)

### Instructor Notes
This exercise focuses on implementing Sarbanes-Oxley (SOX) compliance through comprehensive audit trails and financial data protection. Students will learn to create tamper-evident logging systems, implement segregation of duties, and generate SOX compliance reports.

### Learning Outcomes
- Implement comprehensive audit logging for financial systems
- Create segregation of duties through access controls
- Set up tamper-evident log protection
- Develop automated SOX compliance monitoring
- Generate audit reports for SOX compliance

### Setup Instructions
1. Create sample financial database systems
2. Set up comprehensive audit logging
3. Implement role-based access controls
4. Configure log integrity protection
5. Prepare SOX compliance reporting templates

### Step-by-Step Walkthrough

#### Part A: Financial System Audit Logging
```bash
# Create SOX compliance infrastructure
sudo mkdir -p /opt/sox/{database,logs,reports,scripts,controls}
sudo mkdir -p /opt/sox/logs/{access,changes,admin,financial}

# Set up SOX-specific groups
sudo groupadd sox-admin
sudo groupadd financial-user
sudo groupadd sox-auditor

# Configure audit logging for financial operations
sudo auditctl -w /opt/sox/database -p rwxa -k financial_data_access
sudo auditctl -w /etc/mysql -p wa -k database_config_changes
sudo auditctl -w /var/log/mysql -p wa -k database_log_access
```

#### Part B: Segregation of Duties Implementation
Students will implement role-based access controls to ensure proper segregation of duties as required by SOX.

```bash
#!/bin/bash
# SOX Segregation of Duties Script
# File: /opt/sox/scripts/segregation_of_duties.sh

SOX_BASE="/opt/sox"
AUDIT_LOG="$SOX_BASE/logs/access/segregation_audit.log"

# Function to check role conflicts
check_role_conflicts() {
    local user=$1
    
    echo "$(date): Checking role conflicts for user $user" >> "$AUDIT_LOG"
    
    # Get user's groups
    user_groups=$(groups "$user" 2>/dev/null | cut -d: -f2)
    
    # Check for conflicting roles
    if echo "$user_groups" | grep -q "financial-user" && echo "$user_groups" | grep -q "sox-auditor"; then
        echo "CONFLICT: User $user has both financial-user and sox-auditor roles" >> "$AUDIT_LOG"
        echo "SOX VIOLATION: Role conflict detected for $user"
        return 1
    fi
    
    echo "$(date): No role conflicts found for user $user" >> "$AUDIT_LOG"
    return 0
}

# Function to log financial transactions
log_financial_transaction() {
    local user=$1
    local action=$2
    local amount=$3
    local account=$4
    
    local transaction_log="$SOX_BASE/logs/financial/transactions.log"
    
    echo "$(date)|$user|$action|$amount|$account|$(hostname)" >> "$transaction_log"
    
    # Also log to system audit
    logger -t SOX_FINANCIAL "User: $user, Action: $action, Amount: $amount, Account: $account"
}
```

#### Part C: Tamper-Evident Log Protection
```bash
#!/bin/bash
# SOX Log Integrity Protection Script
# File: /opt/sox/scripts/log_integrity.sh

SOX_BASE="/opt/sox"
INTEGRITY_DIR="$SOX_BASE/integrity"

mkdir -p "$INTEGRITY_DIR"

# Function to create log checksums
create_log_checksums() {
    local log_dir="$SOX_BASE/logs"
    local checksum_file="$INTEGRITY_DIR/log_checksums_$(date +%Y%m%d_%H%M%S).sha256"
    
    echo "Creating log integrity checksums..."
    
    find "$log_dir" -type f -name "*.log" -exec sha256sum {} \; > "$checksum_file"
    
    # Sign the checksum file
    gpg --armor --detach-sign "$checksum_file"
    
    echo "Log checksums created: $checksum_file"
}

# Function to verify log integrity
verify_log_integrity() {
    local checksum_file=$1
    
    if [ ! -f "$checksum_file" ]; then
        echo "Error: Checksum file not found"
        return 1
    fi
    
    echo "Verifying log integrity..."
    
    # Verify GPG signature
    if gpg --verify "$checksum_file.asc" "$checksum_file" 2>/dev/null; then
        echo "GPG signature verified"
    else
        echo "WARNING: GPG signature verification failed"
        return 1
    fi
    
    # Verify checksums
    if sha256sum -c "$checksum_file" --quiet; then
        echo "All log files integrity verified"
        return 0
    else
        echo "WARNING: Log file integrity check failed"
        return 1
    fi
}
```

### Assessment Criteria
- Comprehensive audit trail implementation
- Proper segregation of duties configuration
- Effective log integrity protection
- Quality of SOX compliance monitoring
- Understanding of financial system security requirements

### Advanced Extensions
1. Integration with database audit features
2. Real-time compliance violation alerting
3. Automated SOX report generation
4. Integration with external audit tools

---

## Exercise 3: HIPAA Compliance Access Controls (90 minutes)

### Instructor Notes
This comprehensive exercise teaches students to implement HIPAA (Health Insurance Portability and Accountability Act) compliance through access controls, audit logging, and privacy protection mechanisms. Focus on the technical implementation of HIPAA Security Rule requirements.

### Learning Outcomes
- Implement HIPAA-compliant access controls
- Create comprehensive audit logging for PHI access
- Set up encryption for PHI protection
- Develop breach detection and notification systems
- Generate HIPAA compliance reports

### Setup Instructions
1. Create sample PHI (Protected Health Information) datasets
2. Set up role-based access controls for healthcare roles
3. Implement encryption for PHI protection
4. Configure comprehensive audit logging
5. Prepare HIPAA compliance templates

### Step-by-Step Walkthrough

#### Part A: HIPAA Access Control Implementation
```bash
# Create HIPAA compliance infrastructure
sudo mkdir -p /opt/hipaa/{phi,logs,reports,scripts,policies}
sudo mkdir -p /opt/hipaa/phi/{patient_records,billing,clinical}
sudo mkdir -p /opt/hipaa/logs/{access,admin,security,audit}

# Create HIPAA-specific groups
sudo groupadd hipaa-admin
sudo groupadd healthcare-provider
sudo groupadd billing-staff
sudo groupadd security-officer
sudo groupadd patient

# Set up PHI directory permissions
sudo chown -R root:hipaa-admin /opt/hipaa
sudo chmod -R 750 /opt/hipaa
sudo chmod -R 700 /opt/hipaa/phi
```

#### Part B: PHI Access Monitoring and Logging
```bash
#!/bin/bash
# HIPAA PHI Access Monitoring Script
# File: /opt/hipaa/scripts/phi_access_monitor.sh

HIPAA_BASE="/opt/hipaa"
ACCESS_LOG="$HIPAA_BASE/logs/access/phi_access.log"
AUDIT_LOG="$HIPAA_BASE/logs/audit/hipaa_audit.log"

# Function to log PHI access
log_phi_access() {
    local user=$1
    local action=$2
    local phi_file=$3
    local patient_id=$4
    local purpose=$5
    
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local session_id=$(echo $$ | sha256sum | cut -c1-8)
    
    # Log to PHI access log
    echo "$timestamp|$user|$action|$phi_file|$patient_id|$purpose|$session_id" >> "$ACCESS_LOG"
    
    # Log to HIPAA audit log
    echo "$timestamp|PHI_ACCESS|User:$user|Action:$action|Patient:$patient_id|Purpose:$purpose|Session:$session_id" >> "$AUDIT_LOG"
    
    # Log to system log
    logger -t HIPAA_PHI "User: $user accessed PHI for patient $patient_id, Purpose: $purpose"
}

# Function to check minimum necessary access
check_minimum_necessary() {
    local user=$1
    local requested_data=$2
    local purpose=$3
    
    local user_role=$(groups "$user" | grep -o -E "(healthcare-provider|billing-staff|security-officer)")
    
    case "$user_role" in
        "healthcare-provider")
            if [[ "$purpose" == "treatment" ]]; then
                echo "ACCESS_GRANTED: Healthcare provider accessing for treatment"
                return 0
            fi
            ;;
        "billing-staff")
            if [[ "$purpose" == "payment" && "$requested_data" != *"clinical"* ]]; then
                echo "ACCESS_GRANTED: Billing staff accessing for payment"
                return 0
            fi
            ;;
        "security-officer")
            if [[ "$purpose" == "security" ]]; then
                echo "ACCESS_GRANTED: Security officer accessing for security purposes"
                return 0
            fi
            ;;
    esac
    
    echo "ACCESS_DENIED: Minimum necessary standard not met"
    log_phi_access "$user" "ACCESS_DENIED" "$requested_data" "UNKNOWN" "$purpose"
    return 1
}
```

#### Part C: HIPAA Breach Detection System
```bash
#!/bin/bash
# HIPAA Breach Detection Script
# File: /opt/hipaa/scripts/breach_detection.sh

HIPAA_BASE="/opt/hipaa"
BREACH_LOG="$HIPAA_BASE/logs/security/breach_detection.log"
ALERT_LOG="$HIPAA_BASE/logs/security/breach_alerts.log"

# Function to detect unusual access patterns
detect_unusual_access() {
    local access_log="$HIPAA_BASE/logs/access/phi_access.log"
    local threshold=10
    local time_window=3600  # 1 hour in seconds
    
    echo "$(date): Starting breach detection analysis" >> "$BREACH_LOG"
    
    # Check for excessive access by single user
    current_time=$(date +%s)
    one_hour_ago=$((current_time - time_window))
    
    # Analyze recent access patterns
    awk -F'|' -v start_time="$one_hour_ago" '
    {
        # Convert log timestamp to epoch
        cmd = "date -d \"" $1 "\" +%s"
        cmd | getline log_time
        close(cmd)
        
        if (log_time >= start_time) {
            user_access[$2]++
            total_access++
        }
    }
    END {
        for (user in user_access) {
            if (user_access[user] > 10) {
                print "POTENTIAL_BREACH: User " user " accessed PHI " user_access[user] " times in last hour"
            }
        }
    }' "$access_log" >> "$BREACH_LOG"
    
    # Check for access outside business hours
    current_hour=$(date +%H)
    if [ "$current_hour" -lt 7 ] || [ "$current_hour" -gt 19 ]; then
        recent_access=$(tail -10 "$access_log" | grep "$(date +%Y-%m-%d)")
        if [ -n "$recent_access" ]; then
            echo "$(date): ALERT - PHI access detected outside business hours" >> "$ALERT_LOG"
        fi
    fi
}

# Function to generate breach notification
generate_breach_notification() {
    local incident_id=$1
    local description=$2
    local affected_patients=$3
    
    local notification_file="$HIPAA_BASE/reports/breach_notification_$incident_id.txt"
    
    cat > "$notification_file" << EOF
HIPAA BREACH NOTIFICATION
========================

Incident ID: $incident_id
Date/Time: $(date)
System: $(hostname)

Description: $description
Affected Patients: $affected_patients

Required Actions:
1. Immediate containment of breach
2. Assessment of scope and impact
3. Notification to affected individuals (within 60 days)
4. Notification to HHS (within 60 days)
5. Media notification if breach affects 500+ individuals

Investigation Status: INITIATED
Responsible Officer: Security Officer
Next Review: $(date -d '+24 hours')

EOF

    echo "Breach notification generated: $notification_file"
}
```

### Assessment Criteria
- Proper HIPAA access control implementation
- Comprehensive PHI access logging
- Effective breach detection mechanisms
- Quality of minimum necessary access controls
- Understanding of HIPAA Security Rule requirements

### Troubleshooting Guide
1. **Access Control Issues**: Verify group memberships and file permissions
2. **Logging Problems**: Check log file permissions and disk space
3. **Breach Detection**: Validate log parsing and threshold settings
4. **Performance Impact**: Monitor system performance with extensive logging

---

## Exercise 4: PCI DSS Security Monitoring (75 minutes)

### Instructor Notes
This exercise focuses on implementing PCI DSS (Payment Card Industry Data Security Standard) compliance through security monitoring, vulnerability scanning, and network security controls. Students will learn to create comprehensive security monitoring systems for payment card environments.

### Learning Outcomes
- Implement PCI DSS network security monitoring
- Create vulnerability scanning and assessment systems
- Set up intrusion detection and prevention
- Develop automated PCI DSS compliance checking
- Generate PCI DSS compliance reports

### Setup Instructions
1. Set up test payment processing environment
2. Configure network security monitoring
3. Implement vulnerability scanning tools
4. Set up intrusion detection systems
5. Prepare PCI DSS compliance templates

### Step-by-Step Walkthrough

#### Part A: PCI DSS Network Security Implementation
```bash
# Create PCI DSS compliance infrastructure
sudo mkdir -p /opt/pci/{network,logs,reports,scripts,scans}
sudo mkdir -p /opt/pci/network/{cardholder_data,dmz,internal}
sudo mkdir -p /opt/pci/logs/{firewall,ids,access,vulnerability}

# Create PCI DSS specific groups
sudo groupadd pci-admin
sudo groupadd cardholder-data-access
sudo groupadd network-admin
sudo groupadd security-admin

# Configure firewall logging for PCI compliance
sudo ufw --force enable
sudo ufw logging on
```

#### Part B: Vulnerability Scanning Implementation
```bash
#!/bin/bash
# PCI DSS Vulnerability Scanning Script
# File: /opt/pci/scripts/vulnerability_scan.sh

PCI_BASE="/opt/pci"
SCAN_LOG="$PCI_BASE/logs/vulnerability/scan_results.log"
REPORT_DIR="$PCI_BASE/reports"

# Function to perform network vulnerability scan
perform_vulnerability_scan() {
    local target_network=$1
    local scan_type=$2
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local scan_report="$REPORT_DIR/vuln_scan_$timestamp.txt"
    
    echo "$(date): Starting PCI DSS vulnerability scan" >> "$SCAN_LOG"
    echo "Target: $target_network, Type: $scan_type" >> "$SCAN_LOG"
    
    case "$scan_type" in
        "basic")
            nmap -sV -sC "$target_network" > "$scan_report" 2>&1
            ;;
        "comprehensive")
            nmap -sS -sV -sC -A -O "$target_network" > "$scan_report" 2>&1
            ;;
        "pci_specific")
            # PCI DSS specific vulnerability checks
            nmap --script vuln "$target_network" > "$scan_report" 2>&1
            ;;
    esac
    
    # Analyze scan results for PCI DSS compliance
    analyze_pci_vulnerabilities "$scan_report"
    
    echo "$(date): Vulnerability scan completed: $scan_report" >> "$SCAN_LOG"
}

# Function to analyze vulnerabilities for PCI DSS compliance
analyze_pci_vulnerabilities() {
    local scan_file=$1
    local analysis_file="${scan_file%.txt}_analysis.txt"
    
    echo "=== PCI DSS VULNERABILITY ANALYSIS ===" > "$analysis_file"
    echo "Scan Date: $(date)" >> "$analysis_file"
    echo "" >> "$analysis_file"
    
    # Check for critical PCI DSS vulnerabilities
    echo "=== CRITICAL PCI DSS ISSUES ===" >> "$analysis_file"
    
    # Check for unencrypted services
    if grep -q "telnet\|ftp\|http[^s]" "$scan_file"; then
        echo "HIGH: Unencrypted services detected (PCI DSS Req 4.1)" >> "$analysis_file"
    fi
    
    # Check for default passwords
    if grep -q "default\|admin\|password" "$scan_file"; then
        echo "HIGH: Default credentials detected (PCI DSS Req 2.1)" >> "$analysis_file"
    fi
    
    # Check for unnecessary services
    if grep -q "finger\|echo\|discard" "$scan_file"; then
        echo "MEDIUM: Unnecessary services detected (PCI DSS Req 2.2)" >> "$analysis_file"
    fi
    
    echo "Analysis completed: $analysis_file"
}
```

#### Part C: Intrusion Detection System Setup
```bash
#!/bin/bash
# PCI DSS Intrusion Detection Script
# File: /opt/pci/scripts/intrusion_detection.sh

PCI_BASE="/opt/pci"
IDS_LOG="$PCI_BASE/logs/ids/intrusion_detection.log"
ALERT_LOG="$PCI_BASE/logs/ids/security_alerts.log"

# Function to monitor for PCI DSS security events
monitor_security_events() {
    echo "$(date): Starting PCI DSS intrusion detection monitoring" >> "$IDS_LOG"
    
    # Monitor authentication failures
    tail -f /var/log/auth.log | while read line; do
        if echo "$line" | grep -q "Failed password"; then
            echo "$(date): ALERT - Failed authentication attempt detected" >> "$ALERT_LOG"
            
            # Extract IP address and count failures
            failed_ip=$(echo "$line" | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}')
            if [ -n "$failed_ip" ]; then
                failure_count=$(grep "$failed_ip" /var/log/auth.log | grep "Failed password" | wc -l)
                if [ "$failure_count" -gt 5 ]; then
                    echo "$(date): CRITICAL - Multiple failed attempts from $failed_ip" >> "$ALERT_LOG"
                    # Automatically block IP using fail2ban
                    sudo fail2ban-client set sshd banip "$failed_ip"
                fi
            fi
        fi
    done &
    
    # Monitor network connections for suspicious activity
    netstat -tuln | while read line; do
        if echo "$line" | grep -q ":23\|:21\|:80[^0-9]"; then
            echo "$(date): WARNING - Insecure service detected: $line" >> "$ALERT_LOG"
        fi
    done
}

# Function to generate PCI DSS security report
generate_security_report() {
    local report_file="$PCI_BASE/reports/pci_security_report_$(date +%Y%m%d).txt"
    
    echo "=== PCI DSS SECURITY MONITORING REPORT ===" > "$report_file"
    echo "Generated: $(date)" >> "$report_file"
    echo "System: $(hostname)" >> "$report_file"
    echo "" >> "$report_file"
    
    # Firewall status
    echo "=== FIREWALL STATUS ===" >> "$report_file"
    sudo ufw status verbose >> "$report_file"
    echo "" >> "$report_file"
    
    # Failed authentication attempts
    echo "=== AUTHENTICATION FAILURES (Last 24 hours) ===" >> "$report_file"
    grep "Failed password" /var/log/auth.log | grep "$(date +%b\ %d)" | wc -l >> "$report_file"
    echo "" >> "$report_file"
    
    # Network services
    echo "=== ACTIVE NETWORK SERVICES ===" >> "$report_file"
    netstat -tuln >> "$report_file"
    echo "" >> "$report_file"
    
    # System updates
    echo "=== SECURITY UPDATES ===" >> "$report_file"
    apt list --upgradable 2>/dev/null | grep -i security | wc -l >> "$report_file"
    
    echo "PCI DSS security report generated: $report_file"
}
```

### Assessment Criteria
- Proper PCI DSS network security implementation
- Effective vulnerability scanning and analysis
- Quality of intrusion detection systems
- Comprehensive security monitoring
- Understanding of PCI DSS requirements

### Advanced Extensions
1. Integration with commercial vulnerability scanners
2. Automated compliance report generation
3. Real-time security event correlation
4. Integration with SIEM systems

---

## Integrated Regulatory Compliance Dashboard (30 minutes)

### Instructor Notes
This final exercise integrates all regulatory compliance components into a unified dashboard that provides comprehensive oversight of GDPR, SOX, HIPAA, and PCI DSS compliance status.

### Learning Outcomes
- Integrate multiple regulatory compliance systems
- Create unified compliance reporting
- Implement cross-regulatory compliance monitoring
- Generate executive-level compliance dashboards

### Step-by-Step Walkthrough

#### Unified Compliance Dashboard Creation
```bash
#!/bin/bash
# Unified Regulatory Compliance Dashboard
# File: /opt/compliance/scripts/unified_dashboard.sh

COMPLIANCE_BASE="/opt/compliance"
mkdir -p "$COMPLIANCE_BASE/reports"

# Function to generate unified compliance dashboard
generate_compliance_dashboard() {
    local dashboard_file="$COMPLIANCE_BASE/reports/compliance_dashboard_$(date +%Y%m%d_%H%M%S).html"
    
    cat > "$dashboard_file" << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>ICDFA Regulatory Compliance Dashboard</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .header { background-color: #2c3e50; color: white; padding: 20px; text-align: center; }
        .compliance-section { margin: 20px 0; padding: 15px; border: 1px solid #ddd; }
        .status-good { background-color: #d4edda; border-color: #c3e6cb; }
        .status-warning { background-color: #fff3cd; border-color: #ffeaa7; }
        .status-critical { background-color: #f8d7da; border-color: #f5c6cb; }
        .metric { display: inline-block; margin: 10px; padding: 10px; background-color: #f8f9fa; border-radius: 5px; }
    </style>
</head>
<body>
    <div class="header">
        <h1>ICDFA Regulatory Compliance Dashboard</h1>
        <p>Generated: $(date)</p>
    </div>
EOF

    # Add GDPR compliance status
    echo '    <div class="compliance-section status-good">' >> "$dashboard_file"
    echo '        <h2>🇪🇺 GDPR Compliance Status</h2>' >> "$dashboard_file"
    
    if [ -d "/opt/gdpr" ]; then
        gdpr_policies=$(find /opt/gdpr/policies -name "*.md" 2>/dev/null | wc -l)
        gdpr_logs=$(find /opt/gdpr/logs -name "*.log" -mtime -1 2>/dev/null | wc -l)
        echo "        <div class=\"metric\">Active Policies: $gdpr_policies</div>" >> "$dashboard_file"
        echo "        <div class=\"metric\">Recent Log Entries: $gdpr_logs</div>" >> "$dashboard_file"
    fi
    
    echo '    </div>' >> "$dashboard_file"
    
    # Add SOX compliance status
    echo '    <div class="compliance-section status-good">' >> "$dashboard_file"
    echo '        <h2>📊 SOX Compliance Status</h2>' >> "$dashboard_file"
    
    if [ -d "/opt/sox" ]; then
        sox_audits=$(find /opt/sox/logs -name "*.log" -mtime -1 2>/dev/null | wc -l)
        sox_controls=$(find /opt/sox/controls -name "*.txt" 2>/dev/null | wc -l)
        echo "        <div class=\"metric\">Recent Audits: $sox_audits</div>" >> "$dashboard_file"
        echo "        <div class=\"metric\">Active Controls: $sox_controls</div>" >> "$dashboard_file"
    fi
    
    echo '    </div>' >> "$dashboard_file"
    
    # Add HIPAA compliance status
    echo '    <div class="compliance-section status-warning">' >> "$dashboard_file"
    echo '        <h2>🏥 HIPAA Compliance Status</h2>' >> "$dashboard_file"
    
    if [ -d "/opt/hipaa" ]; then
        hipaa_access=$(find /opt/hipaa/logs/access -name "*.log" -mtime -1 2>/dev/null | wc -l)
        hipaa_breaches=$(grep -r "BREACH" /opt/hipaa/logs 2>/dev/null | wc -l)
        echo "        <div class=\"metric\">PHI Access Logs: $hipaa_access</div>" >> "$dashboard_file"
        echo "        <div class=\"metric\">Breach Incidents: $hipaa_breaches</div>" >> "$dashboard_file"
    fi
    
    echo '    </div>' >> "$dashboard_file"
    
    # Add PCI DSS compliance status
    echo '    <div class="compliance-section status-good">' >> "$dashboard_file"
    echo '        <h2>💳 PCI DSS Compliance Status</h2>' >> "$dashboard_file"
    
    if [ -d "/opt/pci" ]; then
        pci_scans=$(find /opt/pci/reports -name "vuln_scan_*.txt" -mtime -7 2>/dev/null | wc -l)
        pci_alerts=$(find /opt/pci/logs -name "*alert*.log" -mtime -1 2>/dev/null | wc -l)
        echo "        <div class=\"metric\">Weekly Scans: $pci_scans</div>" >> "$dashboard_file"
        echo "        <div class=\"metric\">Security Alerts: $pci_alerts</div>" >> "$dashboard_file"
    fi
    
    echo '    </div>' >> "$dashboard_file"
    
    # Close HTML
    echo '</body></html>' >> "$dashboard_file"
    
    echo "Compliance dashboard generated: $dashboard_file"
}

# Generate the dashboard
generate_compliance_dashboard
```

### Assessment and Grading

#### Comprehensive Assessment Rubric (100 points total)

**Exercise 1: GDPR Compliance (25 points)**
- Data encryption implementation (8 points)
- Access control configuration (6 points)
- Audit logging setup (6 points)
- Data subject rights implementation (5 points)

**Exercise 2: SOX Compliance (25 points)**
- Audit trail implementation (8 points)
- Segregation of duties (7 points)
- Log integrity protection (5 points)
- Financial system monitoring (5 points)

**Exercise 3: HIPAA Compliance (25 points)**
- PHI access controls (8 points)
- Comprehensive audit logging (7 points)
- Breach detection system (5 points)
- Minimum necessary access (5 points)

**Exercise 4: PCI DSS Compliance (25 points)**
- Network security monitoring (8 points)
- Vulnerability scanning (7 points)
- Intrusion detection (5 points)
- Compliance reporting (5 points)

### Post-Lab Activities

#### Reflection Questions
1. How do different regulatory frameworks overlap in their technical requirements?
2. What are the challenges of implementing multiple compliance frameworks simultaneously?
3. How can automation improve regulatory compliance monitoring?
4. What role does Linux play in enterprise regulatory compliance?

#### Follow-Up Assignments
1. Research emerging regulatory requirements (CCPA, GDPR updates)
2. Compare Linux compliance tools with commercial solutions
3. Design a compliance automation strategy
4. Analyze real-world regulatory violation cases

---

*This instructor guide provides comprehensive support for delivering advanced regulatory compliance education using Linux platforms. The exercises demonstrate practical implementation of major regulatory frameworks through hands-on technical implementation.*

