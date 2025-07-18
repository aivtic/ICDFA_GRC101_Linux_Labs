# Week 4 Linux Lab: Compliance Management and Reporting
## Student Lab Manual

**International Cybersecurity and Digital Forensics Academy (ICDFA)**  
**Course: GRC101 - Introduction to Governance, Risk, and Compliance**  
**Lab Duration: 3 hours**  
**Difficulty Level: Advanced**

---

## Lab Overview

Welcome to the final lab of the GRC101 course! In this comprehensive session, you will learn to implement enterprise compliance management using Linux tools and methodologies. You'll create automated compliance monitoring systems, implement audit trail management, develop compliance reporting dashboards, and build comprehensive compliance assessment frameworks.

This lab will give you practical experience with modern compliance frameworks including SOX, GDPR, HIPAA, PCI DSS, and ISO 27001 using real Linux environments and tools.

### What You Will Learn

By the end of this lab, you will be able to:
1. Build automated compliance monitoring and assessment systems
2. Implement comprehensive audit trail management and log analysis
3. Create compliance reporting and dashboard mechanisms
4. Develop policy compliance verification and enforcement tools
5. Implement continuous compliance monitoring frameworks
6. Understand how Linux supports enterprise compliance management
7. Create compliance evidence collection and documentation systems

### Prerequisites

- Completion of Week 1, Week 2, and Week 3 Linux Labs
- Understanding of compliance frameworks from course readings
- Advanced Linux command-line skills and system administration
- Knowledge of regulatory requirements and audit processes
- Familiarity with log analysis and system monitoring
- Understanding of data protection and privacy regulations

---

## Lab Environment Setup

### Required Software Installation

Before starting the exercises, you need to install the required tools and libraries. Follow these steps carefully:

```bash
# Update your system
sudo apt update && sudo apt upgrade -y

# Install Python and compliance analysis libraries
sudo apt install -y python3 python3-pip python3-venv
pip3 install pandas numpy matplotlib seaborn plotly jinja2

# Install database systems
sudo apt install -y sqlite3 mysql-server postgresql

# Install audit and logging tools
sudo apt install -y auditd rsyslog logrotate

# Install security scanning and compliance tools
sudo apt install -y lynis chkrootkit rkhunter aide

# Install document generation tools
sudo apt install -y pandoc wkhtmltopdf texlive-latex-base

# Install additional utilities for data processing
sudo apt install -y jq xmlstarlet csvkit curl wget git

# Verify installations
python3 --version
sqlite3 --version
auditctl --version
```

### Create Lab Directory Structure

Set up the directory structure for your compliance management lab:

```bash
# Create main compliance management directory
sudo mkdir -p /opt/compliance_management/{frameworks,policies,assessments,audits,reporting,evidence}
sudo mkdir -p /opt/compliance_management/frameworks/{sox,gdpr,hipaa,pci_dss,iso27001,nist}
sudo mkdir -p /opt/compliance_management/policies/{security,privacy,operational,technical}
sudo mkdir -p /opt/compliance_management/assessments/{automated,manual,continuous,periodic}
sudo mkdir -p /opt/compliance_management/audits/{internal,external,logs,trails}
sudo mkdir -p /opt/compliance_management/evidence/{documents,logs,screenshots,configurations}
sudo mkdir -p /opt/compliance_management/data/database
sudo mkdir -p /opt/compliance_management/scripts

# Set up proper permissions
sudo chown -R $USER:$USER /opt/compliance_management
chmod -R 755 /opt/compliance_management

# Create log directories
mkdir -p /opt/compliance_management/{assessments,audits,reporting}/logs
```

---

## Exercise 1: Compliance Framework Implementation

### Objective
Create a comprehensive compliance framework using Linux tools that can automatically assess, monitor, and report on compliance with multiple regulatory standards including SOX, GDPR, PCI DSS, and ISO 27001.

### Background
Compliance management is critical for organizations operating in regulated industries. In this exercise, you'll build a system that can:
- Store and manage compliance requirements and frameworks
- Perform automated compliance assessments
- Track compliance status and generate reports
- Manage compliance evidence and documentation

### Step 1: Create the Compliance Management Database

First, you'll create a comprehensive SQLite database to store all compliance-related information:

```bash
# Navigate to the database directory
cd /opt/compliance_management/data/database

# Create the compliance management database
sqlite3 compliance_management.db << 'EOF'
-- Create Compliance Frameworks table
CREATE TABLE IF NOT EXISTS compliance_frameworks (
    framework_id TEXT PRIMARY KEY,
    framework_name TEXT NOT NULL,
    framework_version TEXT NOT NULL,
    description TEXT,
    regulatory_body TEXT,
    industry_sector TEXT,
    mandatory BOOLEAN DEFAULT FALSE,
    effective_date DATE,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Create Compliance Requirements table
CREATE TABLE IF NOT EXISTS compliance_requirements (
    requirement_id TEXT PRIMARY KEY,
    framework_id TEXT NOT NULL,
    requirement_number TEXT NOT NULL,
    requirement_title TEXT NOT NULL,
    requirement_description TEXT NOT NULL,
    control_category TEXT NOT NULL,
    priority_level TEXT NOT NULL,
    implementation_guidance TEXT,
    testing_procedures TEXT,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (framework_id) REFERENCES compliance_frameworks (framework_id)
);

-- Create Policies table
CREATE TABLE IF NOT EXISTS policies (
    policy_id TEXT PRIMARY KEY,
    policy_name TEXT NOT NULL,
    policy_type TEXT NOT NULL,
    policy_category TEXT NOT NULL,
    policy_description TEXT,
    policy_owner TEXT NOT NULL,
    approval_date DATE,
    effective_date DATE,
    review_date DATE,
    status TEXT DEFAULT 'ACTIVE',
    policy_document_path TEXT,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Create Controls table
CREATE TABLE IF NOT EXISTS controls (
    control_id TEXT PRIMARY KEY,
    control_name TEXT NOT NULL,
    control_type TEXT NOT NULL,
    control_family TEXT,
    control_description TEXT NOT NULL,
    implementation_status TEXT NOT NULL,
    control_owner TEXT NOT NULL,
    implementation_date DATE,
    testing_frequency TEXT,
    last_test_date DATE,
    test_results TEXT,
    effectiveness_rating INTEGER,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Create Compliance Assessments table
CREATE TABLE IF NOT EXISTS compliance_assessments (
    assessment_id TEXT PRIMARY KEY,
    framework_id TEXT NOT NULL,
    assessment_type TEXT NOT NULL,
    assessment_scope TEXT NOT NULL,
    assessor TEXT NOT NULL,
    assessment_date DATE NOT NULL,
    assessment_period_start DATE,
    assessment_period_end DATE,
    overall_compliance_score INTEGER,
    compliance_status TEXT,
    findings_summary TEXT,
    recommendations TEXT,
    next_assessment_date DATE,
    status TEXT DEFAULT 'ACTIVE',
    FOREIGN KEY (framework_id) REFERENCES compliance_frameworks (framework_id)
);

-- Create Assessment Results table
CREATE TABLE IF NOT EXISTS assessment_results (
    result_id TEXT PRIMARY KEY,
    assessment_id TEXT NOT NULL,
    requirement_id TEXT NOT NULL,
    control_id TEXT,
    compliance_status TEXT NOT NULL,
    compliance_score INTEGER,
    evidence_collected TEXT,
    gaps_identified TEXT,
    remediation_required TEXT,
    remediation_timeline TEXT,
    responsible_party TEXT,
    testing_notes TEXT,
    FOREIGN KEY (assessment_id) REFERENCES compliance_assessments (assessment_id),
    FOREIGN KEY (requirement_id) REFERENCES compliance_requirements (requirement_id),
    FOREIGN KEY (control_id) REFERENCES controls (control_id)
);

-- Create Compliance Evidence table
CREATE TABLE IF NOT EXISTS compliance_evidence (
    evidence_id TEXT PRIMARY KEY,
    assessment_id TEXT NOT NULL,
    requirement_id TEXT NOT NULL,
    evidence_type TEXT NOT NULL,
    evidence_description TEXT NOT NULL,
    evidence_location TEXT NOT NULL,
    collection_date DATETIME NOT NULL,
    collected_by TEXT NOT NULL,
    evidence_hash TEXT,
    retention_date DATE,
    classification TEXT DEFAULT 'INTERNAL',
    FOREIGN KEY (assessment_id) REFERENCES compliance_assessments (assessment_id),
    FOREIGN KEY (requirement_id) REFERENCES compliance_requirements (requirement_id)
);

-- Insert sample compliance frameworks
INSERT INTO compliance_frameworks VALUES 
('SOX', 'Sarbanes-Oxley Act', '2002', 'Financial reporting and corporate governance', 'SEC/PCAOB', 'Financial Services', TRUE, '2002-07-30', datetime('now'), datetime('now')),
('GDPR', 'General Data Protection Regulation', '2018', 'Data protection and privacy regulation', 'European Commission', 'All Sectors', TRUE, '2018-05-25', datetime('now'), datetime('now')),
('HIPAA', 'Health Insurance Portability and Accountability Act', '1996', 'Healthcare data protection', 'HHS', 'Healthcare', TRUE, '1996-08-21', datetime('now'), datetime('now')),
('PCI_DSS', 'Payment Card Industry Data Security Standard', '4.0', 'Payment card data protection', 'PCI Security Standards Council', 'Payment Processing', TRUE, '2022-03-31', datetime('now'), datetime('now')),
('ISO27001', 'Information Security Management Systems', '2013', 'Information security management', 'ISO', 'All Sectors', FALSE, '2013-10-01', datetime('now'), datetime('now'));

-- Insert sample compliance requirements
INSERT INTO compliance_requirements VALUES 
('SOX_302', 'SOX', '302', 'Corporate Responsibility for Financial Reports', 'Principal executive and financial officers must certify financial reports', 'Financial Reporting', 'HIGH', 'Implement certification process and controls', 'Review certification documentation and processes', datetime('now')),
('SOX_404', 'SOX', '404', 'Management Assessment of Internal Controls', 'Management must assess and report on internal control over financial reporting', 'Internal Controls', 'HIGH', 'Establish ICFR assessment framework', 'Test control design and operating effectiveness', datetime('now')),
('GDPR_25', 'GDPR', '25', 'Data Protection by Design and by Default', 'Implement appropriate technical and organizational measures', 'Privacy Engineering', 'HIGH', 'Integrate privacy into system design', 'Review system architectures and privacy controls', datetime('now')),
('GDPR_32', 'GDPR', '32', 'Security of Processing', 'Implement appropriate technical and organizational security measures', 'Data Security', 'HIGH', 'Implement encryption, access controls, and monitoring', 'Test security controls and incident response', datetime('now')),
('PCI_3.4', 'PCI_DSS', '3.4', 'Render PAN Unreadable', 'Primary account numbers must be rendered unreadable', 'Data Protection', 'CRITICAL', 'Implement strong cryptography and security protocols', 'Test encryption implementation and key management', datetime('now')),
('ISO_A.9.1.1', 'ISO27001', 'A.9.1.1', 'Access Control Policy', 'An access control policy shall be established, documented and reviewed', 'Access Control', 'HIGH', 'Develop comprehensive access control policy', 'Review policy documentation and implementation', datetime('now'));

-- Insert sample policies
INSERT INTO policies VALUES 
('POL_001', 'Information Security Policy', 'Security', 'Information Security', 'Comprehensive information security policy', 'CISO', '2024-01-01', '2024-01-01', '2025-01-01', 'ACTIVE', '/opt/compliance_management/policies/security/info_sec_policy.pdf', datetime('now'), datetime('now')),
('POL_002', 'Data Privacy Policy', 'Privacy', 'Data Protection', 'Data privacy and protection policy', 'DPO', '2024-01-01', '2024-01-01', '2025-01-01', 'ACTIVE', '/opt/compliance_management/policies/privacy/data_privacy_policy.pdf', datetime('now'), datetime('now')),
('POL_003', 'Access Control Policy', 'Security', 'Access Management', 'User access control and management policy', 'IT Security Manager', '2024-01-01', '2024-01-01', '2025-01-01', 'ACTIVE', '/opt/compliance_management/policies/security/access_control_policy.pdf', datetime('now'), datetime('now'));

-- Insert sample controls
INSERT INTO controls VALUES 
('CTRL_001', 'Multi-Factor Authentication', 'Technical', 'Access Control', 'Implement MFA for all privileged accounts', 'IMPLEMENTED', 'IT Security Team', '2024-01-15', 'Monthly', '2024-01-15', 'PASS', 9, datetime('now'), datetime('now')),
('CTRL_002', 'Data Encryption at Rest', 'Technical', 'Data Protection', 'Encrypt sensitive data stored in databases and file systems', 'IMPLEMENTED', 'Database Team', '2024-01-10', 'Quarterly', '2024-01-10', 'PASS', 8, datetime('now'), datetime('now')),
('CTRL_003', 'Security Awareness Training', 'Administrative', 'Human Resources', 'Mandatory security awareness training for all employees', 'IMPLEMENTED', 'HR Department', '2024-01-05', 'Annually', '2024-01-05', 'PASS', 7, datetime('now'), datetime('now')),
('CTRL_004', 'Firewall Configuration', 'Technical', 'Network Security', 'Configure and maintain network firewalls', 'IMPLEMENTED', 'Network Team', '2024-01-08', 'Monthly', '2024-01-08', 'PASS', 8, datetime('now'), datetime('now'));

EOF

echo "Compliance management database created successfully!"
```

### Step 2: Create the Automated Compliance Assessment Engine

Now you'll create a script that can perform automated compliance assessments for different frameworks:

```bash
# Create the compliance assessment engine script
cat > /opt/compliance_management/scripts/compliance_assessment_engine.sh << 'EOF'
#!/bin/bash
# Automated Compliance Assessment Engine

COMPLIANCE_BASE="/opt/compliance_management"
DB_FILE="$COMPLIANCE_BASE/data/database/compliance_management.db"
ASSESSMENT_LOG="$COMPLIANCE_BASE/assessments/logs/assessment.log"
REPORTS_DIR="$COMPLIANCE_BASE/reporting/assessments"
EVIDENCE_DIR="$COMPLIANCE_BASE/evidence"

mkdir -p "$(dirname "$ASSESSMENT_LOG")"
mkdir -p "$REPORTS_DIR"
mkdir -p "$EVIDENCE_DIR"

# Function to perform SOX compliance checks
perform_sox_compliance_check() {
    local assessment_id=$1
    local compliance_score=0
    local total_checks=0
    
    echo "Performing SOX compliance assessment..." >> "$ASSESSMENT_LOG"
    
    # Check 1: Audit logging enabled
    total_checks=$((total_checks + 1))
    if systemctl is-active auditd >/dev/null 2>&1; then
        compliance_score=$((compliance_score + 1))
        record_assessment_result "$assessment_id" "SOX_AUDIT_LOGGING" "COMPLIANT" "Audit logging service is active"
    else
        record_assessment_result "$assessment_id" "SOX_AUDIT_LOGGING" "NON_COMPLIANT" "Audit logging service is not active"
    fi
    
    # Check 2: File integrity monitoring
    total_checks=$((total_checks + 1))
    if command -v aide >/dev/null 2>&1; then
        compliance_score=$((compliance_score + 1))
        record_assessment_result "$assessment_id" "SOX_FILE_INTEGRITY" "COMPLIANT" "File integrity monitoring tool (AIDE) is installed"
    else
        record_assessment_result "$assessment_id" "SOX_FILE_INTEGRITY" "NON_COMPLIANT" "File integrity monitoring tool is not installed"
    fi
    
    # Check 3: User access controls
    total_checks=$((total_checks + 1))
    local privileged_users=$(awk -F: '$3 == 0 {print $1}' /etc/passwd | wc -l)
    if [ "$privileged_users" -le 2 ]; then
        compliance_score=$((compliance_score + 1))
        record_assessment_result "$assessment_id" "SOX_ACCESS_CONTROL" "COMPLIANT" "Appropriate number of privileged users ($privileged_users)"
    else
        record_assessment_result "$assessment_id" "SOX_ACCESS_CONTROL" "NON_COMPLIANT" "Too many privileged users ($privileged_users)"
    fi
    
    # Check 4: Password policy enforcement
    total_checks=$((total_checks + 1))
    if grep -q "minlen" /etc/security/pwquality.conf 2>/dev/null; then
        compliance_score=$((compliance_score + 1))
        record_assessment_result "$assessment_id" "SOX_PASSWORD_POLICY" "COMPLIANT" "Password policy is configured"
    else
        record_assessment_result "$assessment_id" "SOX_PASSWORD_POLICY" "NON_COMPLIANT" "Password policy is not properly configured"
    fi
    
    # Check 5: System backup verification
    total_checks=$((total_checks + 1))
    if crontab -l | grep -q backup 2>/dev/null || systemctl list-units | grep -q backup; then
        compliance_score=$((compliance_score + 1))
        record_assessment_result "$assessment_id" "SOX_BACKUP_CONTROLS" "COMPLIANT" "Backup processes are configured"
    else
        record_assessment_result "$assessment_id" "SOX_BACKUP_CONTROLS" "NON_COMPLIANT" "No backup processes found"
    fi
    
    # Calculate overall compliance percentage
    local compliance_percentage=$((compliance_score * 100 / total_checks))
    
    echo "SOX compliance assessment completed: $compliance_score/$total_checks ($compliance_percentage%)" >> "$ASSESSMENT_LOG"
    
    # Update assessment with overall score
    sqlite3 "$DB_FILE" << EOSQL
UPDATE compliance_assessments 
SET overall_compliance_score = $compliance_percentage,
    compliance_status = CASE 
        WHEN $compliance_percentage >= 90 THEN 'COMPLIANT'
        WHEN $compliance_percentage >= 70 THEN 'PARTIALLY_COMPLIANT'
        ELSE 'NON_COMPLIANT'
    END
WHERE assessment_id = '$assessment_id';
EOSQL

    echo "SOX compliance score: $compliance_percentage%"
}

# Function to perform GDPR compliance checks
perform_gdpr_compliance_check() {
    local assessment_id=$1
    local compliance_score=0
    local total_checks=0
    
    echo "Performing GDPR compliance assessment..." >> "$ASSESSMENT_LOG"
    
    # Check 1: Data encryption at rest
    total_checks=$((total_checks + 1))
    if lsblk -f | grep -q crypt; then
        compliance_score=$((compliance_score + 1))
        record_assessment_result "$assessment_id" "GDPR_ENCRYPTION_REST" "COMPLIANT" "Disk encryption is enabled"
    else
        record_assessment_result "$assessment_id" "GDPR_ENCRYPTION_REST" "NON_COMPLIANT" "Disk encryption is not enabled"
    fi
    
    # Check 2: Data encryption in transit
    total_checks=$((total_checks + 1))
    if systemctl is-active ssh >/dev/null 2>&1 && grep -q "Protocol 2" /etc/ssh/sshd_config 2>/dev/null; then
        compliance_score=$((compliance_score + 1))
        record_assessment_result "$assessment_id" "GDPR_ENCRYPTION_TRANSIT" "COMPLIANT" "Secure protocols are configured"
    else
        record_assessment_result "$assessment_id" "GDPR_ENCRYPTION_TRANSIT" "PARTIALLY_COMPLIANT" "Some secure protocols configured"
    fi
    
    # Check 3: Access logging and monitoring
    total_checks=$((total_checks + 1))
    if [ -f "/var/log/auth.log" ] && [ -s "/var/log/auth.log" ]; then
        compliance_score=$((compliance_score + 1))
        record_assessment_result "$assessment_id" "GDPR_ACCESS_LOGGING" "COMPLIANT" "Access logging is active"
    else
        record_assessment_result "$assessment_id" "GDPR_ACCESS_LOGGING" "NON_COMPLIANT" "Access logging is not properly configured"
    fi
    
    # Check 4: Data retention controls
    total_checks=$((total_checks + 1))
    if [ -f "/etc/logrotate.conf" ] || [ -d "/etc/logrotate.d" ]; then
        compliance_score=$((compliance_score + 1))
        record_assessment_result "$assessment_id" "GDPR_DATA_RETENTION" "COMPLIANT" "Log rotation and retention policies are configured"
    else
        record_assessment_result "$assessment_id" "GDPR_DATA_RETENTION" "NON_COMPLIANT" "Data retention policies are not configured"
    fi
    
    # Check 5: User access controls and authentication
    total_checks=$((total_checks + 1))
    if grep -q "pam_unix.so" /etc/pam.d/common-auth 2>/dev/null; then
        compliance_score=$((compliance_score + 1))
        record_assessment_result "$assessment_id" "GDPR_ACCESS_CONTROL" "COMPLIANT" "Authentication controls are configured"
    else
        record_assessment_result "$assessment_id" "GDPR_ACCESS_CONTROL" "NON_COMPLIANT" "Authentication controls need improvement"
    fi
    
    # Calculate overall compliance percentage
    local compliance_percentage=$((compliance_score * 100 / total_checks))
    
    echo "GDPR compliance assessment completed: $compliance_score/$total_checks ($compliance_percentage%)" >> "$ASSESSMENT_LOG"
    
    # Update assessment with overall score
    sqlite3 "$DB_FILE" << EOSQL
UPDATE compliance_assessments 
SET overall_compliance_score = $compliance_percentage,
    compliance_status = CASE 
        WHEN $compliance_percentage >= 90 THEN 'COMPLIANT'
        WHEN $compliance_percentage >= 70 THEN 'PARTIALLY_COMPLIANT'
        ELSE 'NON_COMPLIANT'
    END
WHERE assessment_id = '$assessment_id';
EOSQL

    echo "GDPR compliance score: $compliance_percentage%"
}

# Function to perform PCI DSS compliance checks
perform_pci_compliance_check() {
    local assessment_id=$1
    local compliance_score=0
    local total_checks=0
    
    echo "Performing PCI DSS compliance assessment..." >> "$ASSESSMENT_LOG"
    
    # Check 1: Firewall configuration
    total_checks=$((total_checks + 1))
    if systemctl is-active ufw >/dev/null 2>&1 || systemctl is-active iptables >/dev/null 2>&1; then
        compliance_score=$((compliance_score + 1))
        record_assessment_result "$assessment_id" "PCI_FIREWALL" "COMPLIANT" "Firewall is active and configured"
    else
        record_assessment_result "$assessment_id" "PCI_FIREWALL" "NON_COMPLIANT" "Firewall is not properly configured"
    fi
    
    # Check 2: Default passwords changed
    total_checks=$((total_checks + 1))
    local default_accounts=$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | wc -l)
    if [ "$default_accounts" -gt 0 ]; then
        compliance_score=$((compliance_score + 1))
        record_assessment_result "$assessment_id" "PCI_DEFAULT_PASSWORDS" "COMPLIANT" "User accounts are properly configured"
    else
        record_assessment_result "$assessment_id" "PCI_DEFAULT_PASSWORDS" "NON_COMPLIANT" "Default account configuration issues"
    fi
    
    # Check 3: Data encryption
    total_checks=$((total_checks + 1))
    if command -v openssl >/dev/null 2>&1; then
        compliance_score=$((compliance_score + 1))
        record_assessment_result "$assessment_id" "PCI_ENCRYPTION" "COMPLIANT" "Encryption tools are available"
    else
        record_assessment_result "$assessment_id" "PCI_ENCRYPTION" "NON_COMPLIANT" "Encryption tools are not installed"
    fi
    
    # Check 4: Antivirus software
    total_checks=$((total_checks + 1))
    if command -v clamav >/dev/null 2>&1 || command -v rkhunter >/dev/null 2>&1; then
        compliance_score=$((compliance_score + 1))
        record_assessment_result "$assessment_id" "PCI_ANTIVIRUS" "COMPLIANT" "Antivirus/anti-malware tools are installed"
    else
        record_assessment_result "$assessment_id" "PCI_ANTIVIRUS" "NON_COMPLIANT" "Antivirus/anti-malware tools are not installed"
    fi
    
    # Check 5: Security updates
    total_checks=$((total_checks + 1))
    local security_updates=$(apt list --upgradable 2>/dev/null | grep -i security | wc -l)
    if [ "$security_updates" -eq 0 ]; then
        compliance_score=$((compliance_score + 1))
        record_assessment_result "$assessment_id" "PCI_SECURITY_UPDATES" "COMPLIANT" "System is up to date with security patches"
    else
        record_assessment_result "$assessment_id" "PCI_SECURITY_UPDATES" "NON_COMPLIANT" "$security_updates security updates are pending"
    fi
    
    # Calculate overall compliance percentage
    local compliance_percentage=$((compliance_score * 100 / total_checks))
    
    echo "PCI DSS compliance assessment completed: $compliance_score/$total_checks ($compliance_percentage%)" >> "$ASSESSMENT_LOG"
    
    # Update assessment with overall score
    sqlite3 "$DB_FILE" << EOSQL
UPDATE compliance_assessments 
SET overall_compliance_score = $compliance_percentage,
    compliance_status = CASE 
        WHEN $compliance_percentage >= 90 THEN 'COMPLIANT'
        WHEN $compliance_percentage >= 70 THEN 'PARTIALLY_COMPLIANT'
        ELSE 'NON_COMPLIANT'
    END
WHERE assessment_id = '$assessment_id';
EOSQL

    echo "PCI DSS compliance score: $compliance_percentage%"
}

# Function to record individual assessment results
record_assessment_result() {
    local assessment_id=$1
    local requirement_id=$2
    local compliance_status=$3
    local evidence=$4
    
    local result_id="RESULT_$(date +%Y%m%d_%H%M%S)_$$"
    
    # Calculate compliance score based on status
    local compliance_score
    case "$compliance_status" in
        "COMPLIANT") compliance_score=100 ;;
        "PARTIALLY_COMPLIANT") compliance_score=50 ;;
        "NON_COMPLIANT") compliance_score=0 ;;
        *) compliance_score=0 ;;
    esac
    
    sqlite3 "$DB_FILE" << EOSQL
INSERT INTO assessment_results (
    result_id, assessment_id, requirement_id, compliance_status, 
    compliance_score, evidence_collected, testing_notes
) VALUES (
    '$result_id', '$assessment_id', '$requirement_id', '$compliance_status',
    $compliance_score, '$evidence', 'Automated system check performed'
);
EOSQL

    echo "$(date): Recorded result $result_id for $requirement_id: $compliance_status" >> "$ASSESSMENT_LOG"
}

# Function to create new compliance assessment
create_compliance_assessment() {
    local framework_id=$1
    local assessment_type=$2
    local assessment_scope=$3
    local assessor=$4
    
    local assessment_id="ASSESS_$(date +%Y%m%d_%H%M%S)_$$"
    local assessment_date=$(date +%Y-%m-%d)
    
    sqlite3 "$DB_FILE" << EOSQL
INSERT INTO compliance_assessments (
    assessment_id, framework_id, assessment_type, assessment_scope,
    assessor, assessment_date, status
) VALUES (
    '$assessment_id', '$framework_id', '$assessment_type', '$assessment_scope',
    '$assessor', '$assessment_date', 'ACTIVE'
);
EOSQL

    echo "$assessment_id"
}

# Function to perform system compliance checks
perform_system_compliance_check() {
    local framework=$1
    local assessment_id=$2
    
    echo "$(date): Performing $framework system compliance check" >> "$ASSESSMENT_LOG"
    
    case "$framework" in
        "SOX")
            perform_sox_compliance_check "$assessment_id"
            ;;
        "GDPR")
            perform_gdpr_compliance_check "$assessment_id"
            ;;
        "PCI_DSS")
            perform_pci_compliance_check "$assessment_id"
            ;;
        *)
            echo "Framework $framework not yet implemented"
            return 1
            ;;
    esac
}

# Function to generate compliance assessment report
generate_compliance_report() {
    local assessment_id=$1
    local report_file="$REPORTS_DIR/compliance_report_$assessment_id.txt"
    
    # Create comprehensive compliance report
    cat > "$report_file" << EOREPORT
========================================
COMPLIANCE ASSESSMENT REPORT
========================================

$(sqlite3 "$DB_FILE" "
SELECT 'Assessment ID: ' || ca.assessment_id || char(10) ||
       'Framework: ' || cf.framework_name || char(10) ||
       'Assessment Type: ' || ca.assessment_type || char(10) ||
       'Assessment Scope: ' || ca.assessment_scope || char(10) ||
       'Assessor: ' || ca.assessor || char(10) ||
       'Assessment Date: ' || ca.assessment_date || char(10) ||
       'Overall Compliance Score: ' || COALESCE(ca.overall_compliance_score, 'Pending') || '%' || char(10) ||
       'Compliance Status: ' || COALESCE(ca.compliance_status, 'Pending')
FROM compliance_assessments ca
JOIN compliance_frameworks cf ON ca.framework_id = cf.framework_id
WHERE ca.assessment_id = '$assessment_id';
")

DETAILED ASSESSMENT RESULTS:
============================

$(sqlite3 "$DB_FILE" "
.mode column
.headers on
SELECT 
    ar.requirement_id as 'Requirement',
    ar.compliance_status as 'Status',
    ar.compliance_score as 'Score',
    ar.evidence_collected as 'Evidence'
FROM assessment_results ar
WHERE ar.assessment_id = '$assessment_id'
ORDER BY ar.compliance_score ASC;
")

COMPLIANCE SUMMARY:
==================

$(sqlite3 "$DB_FILE" "
SELECT 'Total Requirements Assessed: ' || COUNT(*) || char(10) ||
       'Compliant: ' || SUM(CASE WHEN compliance_status = 'COMPLIANT' THEN 1 ELSE 0 END) || char(10) ||
       'Partially Compliant: ' || SUM(CASE WHEN compliance_status = 'PARTIALLY_COMPLIANT' THEN 1 ELSE 0 END) || char(10) ||
       'Non-Compliant: ' || SUM(CASE WHEN compliance_status = 'NON_COMPLIANT' THEN 1 ELSE 0 END) || char(10) ||
       'Average Compliance Score: ' || ROUND(AVG(compliance_score), 2) || '%'
FROM assessment_results
WHERE assessment_id = '$assessment_id';
")

RECOMMENDATIONS:
===============

$(sqlite3 "$DB_FILE" "
SELECT 'Non-Compliant Requirements:' || char(10) ||
       GROUP_CONCAT('- ' || requirement_id || ': ' || evidence_collected, char(10))
FROM assessment_results
WHERE assessment_id = '$assessment_id' AND compliance_status = 'NON_COMPLIANT';
")

NEXT STEPS:
==========
1. Address all non-compliant requirements immediately
2. Develop remediation plans for partially compliant items
3. Schedule follow-up assessments for critical findings
4. Update policies and procedures as needed
5. Provide additional training where gaps are identified

Report Generated: $(date)
========================================
EOREPORT

    echo "Compliance assessment report generated: $report_file"
}

# Main script logic
case "$1" in
    "assess")
        if [ $# -ne 5 ]; then
            echo "Usage: $0 assess <framework> <assessment_type> <scope> <assessor>"
            echo "Example: $0 assess SOX automated 'Financial Systems' 'John Doe'"
            exit 1
        fi
        
        framework=$2
        assessment_type=$3
        scope=$4
        assessor=$5
        
        # Create new assessment
        assessment_id=$(create_compliance_assessment "$framework" "$assessment_type" "$scope" "$assessor")
        echo "Created assessment: $assessment_id"
        
        # Perform compliance checks
        perform_system_compliance_check "$framework" "$assessment_id"
        
        # Generate report
        generate_compliance_report "$assessment_id"
        ;;
    "report")
        if [ $# -ne 2 ]; then
            echo "Usage: $0 report <assessment_id>"
            exit 1
        fi
        generate_compliance_report "$2"
        ;;
    *)
        echo "Usage: $0 {assess|report} [arguments]"
        echo "  assess: Perform compliance assessment"
        echo "  report: Generate compliance report"
        exit 1
        ;;
esac
EOF

# Make the script executable
chmod +x /opt/compliance_management/scripts/compliance_assessment_engine.sh
```

### Step 3: Perform Compliance Assessments

Now let's perform compliance assessments for different frameworks:

```bash
# Navigate to the scripts directory
cd /opt/compliance_management/scripts

# Perform SOX compliance assessment
echo "Performing SOX compliance assessment..."
./compliance_assessment_engine.sh assess SOX automated "Financial Reporting Systems" "$(whoami)"

# Perform GDPR compliance assessment
echo "Performing GDPR compliance assessment..."
./compliance_assessment_engine.sh assess GDPR automated "Data Processing Systems" "$(whoami)"

# Perform PCI DSS compliance assessment
echo "Performing PCI DSS compliance assessment..."
./compliance_assessment_engine.sh assess PCI_DSS automated "Payment Processing Systems" "$(whoami)"

echo "All compliance assessments completed!"
```

### Step 4: View Assessment Results

Check the results of your compliance assessments:

```bash
# View the assessment logs
echo "=== COMPLIANCE ASSESSMENT LOG ==="
tail -20 /opt/compliance_management/assessments/logs/assessment.log

# View the database contents
echo "=== COMPLIANCE ASSESSMENTS ==="
sqlite3 /opt/compliance_management/data/database/compliance_management.db << 'EOF'
.mode column
.headers on
SELECT 
    ca.assessment_id,
    cf.framework_name,
    ca.assessment_date,
    ca.overall_compliance_score,
    ca.compliance_status
FROM compliance_assessments ca
JOIN compliance_frameworks cf ON ca.framework_id = cf.framework_id
ORDER BY ca.assessment_date DESC;
EOF

# View assessment results details
echo "=== ASSESSMENT RESULTS SUMMARY ==="
sqlite3 /opt/compliance_management/data/database/compliance_management.db << 'EOF'
.mode column
.headers on
SELECT 
    ar.requirement_id,
    ar.compliance_status,
    ar.compliance_score,
    ar.evidence_collected
FROM assessment_results ar
ORDER BY ar.compliance_score ASC
LIMIT 10;
EOF

# View the latest compliance report
echo "=== LATEST COMPLIANCE REPORT ==="
latest_report=$(ls -t /opt/compliance_management/reporting/assessments/compliance_report_*.txt | head -1)
if [ -n "$latest_report" ]; then
    cat "$latest_report"
fi
```

### Questions for Exercise 1:

1. **Framework Comparison**: How do the compliance requirements differ between SOX, GDPR, and PCI DSS?

2. **Automated Assessment**: What are the advantages and limitations of automated compliance assessments?

3. **Compliance Scoring**: How would you improve the compliance scoring methodology?

4. **Evidence Collection**: What types of evidence would be most valuable for compliance audits?

---

## Exercise 2: Audit Trail Management and Log Analysis

### Objective
Implement a comprehensive audit trail management system that can collect, analyze, and report on system activities for compliance purposes. This system will support regulatory requirements for audit trails and log retention.

### Background
Audit trails are critical for compliance with most regulatory frameworks. In this exercise, you'll build systems that:
- Configure comprehensive system logging and audit trails
- Collect and analyze audit logs for compliance events
- Implement log retention and archival policies
- Generate audit reports for compliance purposes

### Step 1: Configure Comprehensive Audit Logging

```bash
# Create the audit trail management script
cat > /opt/compliance_management/scripts/audit_trail_management.sh << 'EOF'
#!/bin/bash
# Comprehensive Audit Trail Management System

COMPLIANCE_BASE="/opt/compliance_management"
AUDIT_DIR="$COMPLIANCE_BASE/audits"
LOG_DIR="$AUDIT_DIR/logs"
ANALYSIS_DIR="$AUDIT_DIR/analysis"
ARCHIVE_DIR="$AUDIT_DIR/archive"
REPORTS_DIR="$AUDIT_DIR/reports"

mkdir -p "$LOG_DIR" "$ANALYSIS_DIR" "$ARCHIVE_DIR" "$REPORTS_DIR"

# Function to configure comprehensive audit logging
configure_audit_logging() {
    echo "Configuring comprehensive audit logging..."
    
    # Enable auditd service
    sudo systemctl enable auditd
    sudo systemctl start auditd
    
    # Configure audit rules for compliance
    sudo tee /etc/audit/rules.d/compliance.rules << 'EORULES'
# Compliance-focused audit rules

# Monitor file access and modifications
-w /etc/passwd -p wa -k user_accounts
-w /etc/group -p wa -k user_accounts
-w /etc/shadow -p wa -k user_accounts
-w /etc/sudoers -p wa -k privilege_escalation

# Monitor system configuration changes
-w /etc/ssh/sshd_config -p wa -k ssh_config
-w /etc/hosts -p wa -k network_config
-w /etc/network/ -p wa -k network_config

# Monitor authentication events
-w /var/log/auth.log -p wa -k authentication
-w /var/log/secure -p wa -k authentication

# Monitor privileged commands
-a always,exit -F arch=b64 -S execve -F euid=0 -k privileged_commands
-a always,exit -F arch=b32 -S execve -F euid=0 -k privileged_commands

# Monitor file system mounts
-a always,exit -F arch=b64 -S mount -k filesystem_mounts
-a always,exit -F arch=b32 -S mount -k filesystem_mounts

# Monitor file deletions
-a always,exit -F arch=b64 -S unlink -S unlinkat -S rename -S renameat -k file_deletion
-a always,exit -F arch=b32 -S unlink -S unlinkat -S rename -S renameat -k file_deletion

# Monitor permission changes
-a always,exit -F arch=b64 -S chmod -S fchmod -S fchmodat -k permission_changes
-a always,exit -F arch=b32 -S chmod -S fchmod -S fchmodat -k permission_changes
EORULES

    # Restart auditd to apply new rules
    sudo systemctl restart auditd
    
    echo "Audit logging configuration completed"
}

# Function to configure log retention and rotation
configure_log_retention() {
    echo "Configuring log retention policies..."
    
    # Create compliance-specific logrotate configuration
    sudo tee /etc/logrotate.d/compliance << 'EOROTATE'
# Compliance log retention configuration

/var/log/audit/audit.log {
    daily
    rotate 2555  # 7 years retention
    compress
    delaycompress
    missingok
    notifempty
    create 0640 root adm
    postrotate
        /sbin/service auditd restart > /dev/null 2>&1 || true
    endscript
}

/var/log/auth.log {
    daily
    rotate 2555  # 7 years retention
    compress
    delaycompress
    missingok
    notifempty
    create 0640 syslog adm
    postrotate
        /usr/lib/rsyslog/rsyslog-rotate
    endscript
}

/var/log/syslog {
    daily
    rotate 365   # 1 year retention
    compress
    delaycompress
    missingok
    notifempty
    create 0640 syslog adm
    postrotate
        /usr/lib/rsyslog/rsyslog-rotate
    endscript
}
EOROTATE

    echo "Log retention configuration completed"
}

# Function to collect and analyze audit logs
collect_audit_logs() {
    local collection_date=$(date +%Y%m%d_%H%M%S)
    local collection_dir="$LOG_DIR/collection_$collection_date"
    
    mkdir -p "$collection_dir"
    
    echo "Collecting audit logs for analysis..."
    
    # Collect system audit logs
    if [ -f "/var/log/audit/audit.log" ]; then
        cp /var/log/audit/audit.log "$collection_dir/audit.log"
    fi
    
    # Collect authentication logs
    if [ -f "/var/log/auth.log" ]; then
        cp /var/log/auth.log "$collection_dir/auth.log"
    fi
    
    # Collect system logs
    if [ -f "/var/log/syslog" ]; then
        cp /var/log/syslog "$collection_dir/syslog"
    fi
    
    # Create collection manifest
    cat > "$collection_dir/collection_manifest.txt" << EOMANIFEST
Audit Log Collection Manifest
=============================
Collection Date: $(date)
Collection ID: collection_$collection_date
Collected By: $(whoami)
System: $(hostname)

Files Collected:
$(ls -la "$collection_dir" | grep -v "^total" | grep -v "collection_manifest.txt")

Collection Hash:
$(find "$collection_dir" -type f ! -name "collection_manifest.txt" -exec sha256sum {} \; | sort)
EOMANIFEST

    echo "Audit logs collected in: $collection_dir"
    echo "$collection_dir"
}

# Function to analyze audit logs for compliance events
analyze_audit_logs() {
    local collection_dir=$1
    local analysis_id="ANALYSIS_$(date +%Y%m%d_%H%M%S)"
    local analysis_file="$ANALYSIS_DIR/audit_analysis_$analysis_id.txt"
    
    echo "Performing audit log analysis..."
    
    cat > "$analysis_file" << EOANALYSIS
========================================
AUDIT LOG ANALYSIS REPORT
========================================
Analysis ID: $analysis_id
Analysis Date: $(date)
Collection Directory: $collection_dir
Analyst: $(whoami)

AUTHENTICATION EVENTS ANALYSIS:
==============================

EOANALYSIS

    # Analyze authentication events
    if [ -f "$collection_dir/auth.log" ]; then
        echo "Successful Logins:" >> "$analysis_file"
        grep "Accepted" "$collection_dir/auth.log" | tail -10 >> "$analysis_file"
        echo "" >> "$analysis_file"
        
        echo "Failed Login Attempts:" >> "$analysis_file"
        grep "Failed password" "$collection_dir/auth.log" | tail -10 >> "$analysis_file"
        echo "" >> "$analysis_file"
        
        echo "Privilege Escalation Events:" >> "$analysis_file"
        grep -E "(sudo|su)" "$collection_dir/auth.log" | tail -10 >> "$analysis_file"
        echo "" >> "$analysis_file"
    fi
    
    # Analyze system audit events
    if [ -f "$collection_dir/audit.log" ]; then
        echo "SYSTEM AUDIT EVENTS ANALYSIS:" >> "$analysis_file"
        echo "=============================" >> "$analysis_file"
        echo "" >> "$analysis_file"
        
        echo "File Access Events:" >> "$analysis_file"
        grep "type=PATH" "$collection_dir/audit.log" | tail -5 >> "$analysis_file"
        echo "" >> "$analysis_file"
        
        echo "System Call Events:" >> "$analysis_file"
        grep "type=SYSCALL" "$collection_dir/audit.log" | tail -5 >> "$analysis_file"
        echo "" >> "$analysis_file"
        
        echo "User Account Events:" >> "$analysis_file"
        grep -E "(user_accounts|privilege_escalation)" "$collection_dir/audit.log" | tail -5 >> "$analysis_file"
        echo "" >> "$analysis_file"
    fi
    
    # Generate compliance-specific analysis
    echo "COMPLIANCE-SPECIFIC FINDINGS:" >> "$analysis_file"
    echo "=============================" >> "$analysis_file"
    echo "" >> "$analysis_file"
    
    # SOX-related events
    echo "SOX-Related Events:" >> "$analysis_file"
    if [ -f "$collection_dir/audit.log" ]; then
        grep -E "(financial|accounting|database)" "$collection_dir/audit.log" | wc -l | xargs echo "Financial system access events:" >> "$analysis_file"
    fi
    
    # GDPR-related events
    echo "GDPR-Related Events:" >> "$analysis_file"
    if [ -f "$collection_dir/auth.log" ]; then
        grep -E "(data|privacy|personal)" "$collection_dir/auth.log" | wc -l | xargs echo "Data access events:" >> "$analysis_file"
    fi
    
    # Generate summary statistics
    echo "" >> "$analysis_file"
    echo "SUMMARY STATISTICS:" >> "$analysis_file"
    echo "==================" >> "$analysis_file"
    
    if [ -f "$collection_dir/auth.log" ]; then
        echo "Total authentication events: $(wc -l < "$collection_dir/auth.log")" >> "$analysis_file"
        echo "Successful logins: $(grep -c "Accepted" "$collection_dir/auth.log" 2>/dev/null || echo "0")" >> "$analysis_file"
        echo "Failed login attempts: $(grep -c "Failed password" "$collection_dir/auth.log" 2>/dev/null || echo "0")" >> "$analysis_file"
    fi
    
    if [ -f "$collection_dir/audit.log" ]; then
        echo "Total audit events: $(wc -l < "$collection_dir/audit.log")" >> "$analysis_file"
        echo "System call events: $(grep -c "type=SYSCALL" "$collection_dir/audit.log" 2>/dev/null || echo "0")" >> "$analysis_file"
        echo "File access events: $(grep -c "type=PATH" "$collection_dir/audit.log" 2>/dev/null || echo "0")" >> "$analysis_file"
    fi
    
    echo "" >> "$analysis_file"
    echo "Analysis completed: $(date)" >> "$analysis_file"
    echo "========================================" >> "$analysis_file"
    
    echo "Audit log analysis completed: $analysis_file"
    echo "$analysis_file"
}

# Function to generate compliance audit report
generate_compliance_audit_report() {
    local framework=$1
    local period_start=$2
    local period_end=$3
    local report_id="AUDIT_REPORT_$(date +%Y%m%d_%H%M%S)"
    local report_file="$REPORTS_DIR/compliance_audit_report_$report_id.txt"
    
    echo "Generating compliance audit report for $framework..."
    
    cat > "$report_file" << EOREPORT
========================================
COMPLIANCE AUDIT REPORT
========================================
Report ID: $report_id
Framework: $framework
Audit Period: $period_start to $period_end
Report Date: $(date)
Auditor: $(whoami)
System: $(hostname)

AUDIT SCOPE AND OBJECTIVES:
===========================
This audit report covers the compliance audit trail analysis for the $framework framework
during the period from $period_start to $period_end. The objective is to verify that
appropriate audit trails are maintained and that compliance-relevant events are properly
logged and monitored.

AUDIT METHODOLOGY:
==================
1. Collection of system audit logs and authentication logs
2. Analysis of compliance-relevant events and activities
3. Verification of audit trail completeness and integrity
4. Assessment of log retention and archival processes
5. Review of audit trail monitoring and alerting mechanisms

AUDIT FINDINGS:
===============

EOREPORT

    # Framework-specific audit findings
    case "$framework" in
        "SOX")
            echo "SOX-Specific Audit Findings:" >> "$report_file"
            echo "- Financial system access logging: $(grep -c "financial\|accounting\|database" /var/log/audit/audit.log 2>/dev/null || echo "0") events" >> "$report_file"
            echo "- Privileged user activity: $(grep -c "sudo\|su" /var/log/auth.log 2>/dev/null || echo "0") events" >> "$report_file"
            echo "- System configuration changes: $(grep -c "config" /var/log/audit/audit.log 2>/dev/null || echo "0") events" >> "$report_file"
            ;;
        "GDPR")
            echo "GDPR-Specific Audit Findings:" >> "$report_file"
            echo "- Data access events: $(grep -c "data\|privacy\|personal" /var/log/auth.log 2>/dev/null || echo "0") events" >> "$report_file"
            echo "- User authentication events: $(grep -c "Accepted\|Failed" /var/log/auth.log 2>/dev/null || echo "0") events" >> "$report_file"
            echo "- File access and modification: $(grep -c "type=PATH" /var/log/audit/audit.log 2>/dev/null || echo "0") events" >> "$report_file"
            ;;
        "PCI_DSS")
            echo "PCI DSS-Specific Audit Findings:" >> "$report_file"
            echo "- Payment system access: $(grep -c "payment\|card\|transaction" /var/log/audit/audit.log 2>/dev/null || echo "0") events" >> "$report_file"
            echo "- Network access events: $(grep -c "network\|connection" /var/log/audit/audit.log 2>/dev/null || echo "0") events" >> "$report_file"
            echo "- Security control events: $(grep -c "security\|firewall" /var/log/syslog 2>/dev/null || echo "0") events" >> "$report_file"
            ;;
    esac
    
    echo "" >> "$report_file"
    echo "AUDIT TRAIL INTEGRITY VERIFICATION:" >> "$report_file"
    echo "====================================" >> "$report_file"
    
    # Verify audit log integrity
    if [ -f "/var/log/audit/audit.log" ]; then
        echo "Audit log file size: $(stat -c%s /var/log/audit/audit.log) bytes" >> "$report_file"
        echo "Audit log last modified: $(stat -c%y /var/log/audit/audit.log)" >> "$report_file"
        echo "Audit log permissions: $(stat -c%A /var/log/audit/audit.log)" >> "$report_file"
    fi
    
    echo "" >> "$report_file"
    echo "LOG RETENTION COMPLIANCE:" >> "$report_file"
    echo "=========================" >> "$report_file"
    
    # Check log retention compliance
    local log_files=$(find /var/log -name "*.log" -type f | wc -l)
    local archived_logs=$(find /var/log -name "*.gz" -type f | wc -l)
    
    echo "Active log files: $log_files" >> "$report_file"
    echo "Archived log files: $archived_logs" >> "$report_file"
    echo "Log rotation configuration: $([ -f "/etc/logrotate.d/compliance" ] && echo "Configured" || echo "Not configured")" >> "$report_file"
    
    echo "" >> "$report_file"
    echo "RECOMMENDATIONS:" >> "$report_file"
    echo "================" >> "$report_file"
    echo "1. Ensure all compliance-relevant events are properly logged" >> "$report_file"
    echo "2. Implement automated log analysis and alerting" >> "$report_file"
    echo "3. Verify log retention policies meet regulatory requirements" >> "$report_file"
    echo "4. Conduct regular audit trail integrity checks" >> "$report_file"
    echo "5. Provide audit trail training for relevant personnel" >> "$report_file"
    
    echo "" >> "$report_file"
    echo "AUDIT CONCLUSION:" >> "$report_file"
    echo "=================" >> "$report_file"
    echo "The audit trail analysis indicates that basic logging mechanisms are in place." >> "$report_file"
    echo "However, additional enhancements may be required to fully meet $framework requirements." >> "$report_file"
    echo "Refer to the recommendations section for specific improvement actions." >> "$report_file"
    
    echo "" >> "$report_file"
    echo "Report generated: $(date)" >> "$report_file"
    echo "========================================" >> "$report_file"
    
    echo "Compliance audit report generated: $report_file"
    echo "$report_file"
}

# Main script logic
case "$1" in
    "configure")
        configure_audit_logging
        configure_log_retention
        ;;
    "collect")
        collection_dir=$(collect_audit_logs)
        echo "Collection completed: $collection_dir"
        ;;
    "analyze")
        if [ $# -ne 2 ]; then
            echo "Usage: $0 analyze <collection_directory>"
            exit 1
        fi
        analyze_audit_logs "$2"
        ;;
    "report")
        if [ $# -ne 4 ]; then
            echo "Usage: $0 report <framework> <start_date> <end_date>"
            echo "Example: $0 report SOX 2024-01-01 2024-01-31"
            exit 1
        fi
        generate_compliance_audit_report "$2" "$3" "$4"
        ;;
    "full")
        echo "Performing full audit trail management cycle..."
        configure_audit_logging
        configure_log_retention
        collection_dir=$(collect_audit_logs)
        analyze_audit_logs "$collection_dir"
        echo "Full audit trail management cycle completed"
        ;;
    *)
        echo "Usage: $0 {configure|collect|analyze|report|full} [arguments]"
        echo "  configure: Configure audit logging and retention"
        echo "  collect: Collect current audit logs"
        echo "  analyze: Analyze collected audit logs"
        echo "  report: Generate compliance audit report"
        echo "  full: Perform complete audit trail management cycle"
        exit 1
        ;;
esac
EOF

# Make the script executable
chmod +x /opt/compliance_management/scripts/audit_trail_management.sh
```

### Step 2: Configure and Test Audit Trail Management

```bash
# Navigate to the scripts directory
cd /opt/compliance_management/scripts

# Configure audit logging and retention
echo "Configuring audit trail management..."
./audit_trail_management.sh configure

# Collect current audit logs
echo "Collecting audit logs..."
collection_dir=$(./audit_trail_management.sh collect)

# Analyze the collected logs
echo "Analyzing audit logs..."
./audit_trail_management.sh analyze "$collection_dir"

# Generate compliance audit reports
echo "Generating compliance audit reports..."
./audit_trail_management.sh report SOX 2024-01-01 2024-12-31
./audit_trail_management.sh report GDPR 2024-01-01 2024-12-31
```

### Step 3: Review Audit Trail Results

```bash
# Check audit configuration
echo "=== AUDIT CONFIGURATION STATUS ==="
sudo systemctl status auditd
sudo auditctl -l

# View collected audit logs
echo "=== COLLECTED AUDIT LOGS ==="
ls -la /opt/compliance_management/audits/logs/

# View audit analysis results
echo "=== AUDIT ANALYSIS RESULTS ==="
latest_analysis=$(ls -t /opt/compliance_management/audits/analysis/audit_analysis_*.txt | head -1)
if [ -n "$latest_analysis" ]; then
    echo "Latest Analysis Report:"
    cat "$latest_analysis"
fi

# View compliance audit reports
echo "=== COMPLIANCE AUDIT REPORTS ==="
ls -la /opt/compliance_management/audits/reports/
```

### Questions for Exercise 2:

1. **Audit Trail Requirements**: How do audit trail requirements differ across compliance frameworks?

2. **Log Analysis**: What patterns in audit logs would indicate potential compliance violations?

3. **Retention Policies**: How would you determine appropriate log retention periods for different types of data?

4. **Integrity Protection**: What measures would you implement to protect audit log integrity?

---

## Exercise 3: Compliance Reporting and Dashboard Creation

### Objective
Implement a comprehensive compliance reporting and dashboard system that can generate executive summaries, regulatory reports, and interactive visualizations of compliance status across multiple frameworks.

### Background
Effective compliance reporting is essential for communicating compliance status to different stakeholders. In this exercise, you'll build systems that:
- Create automated compliance dashboards and visualizations
- Generate executive-level compliance summaries
- Produce regulatory-specific compliance reports
- Provide trend analysis and compliance forecasting

### Step 1: Install Additional Python Libraries

```bash
# Install additional Python libraries for advanced reporting
pip3 install matplotlib seaborn plotly jinja2

# Verify installation
python3 -c "import matplotlib, seaborn, plotly, jinja2; print('All reporting libraries installed successfully')"
```

### Step 2: Create the Compliance Dashboard System

```bash
# Create the compliance dashboard Python script
cat > /opt/compliance_management/scripts/compliance_dashboard.py << 'EOF'
#!/usr/bin/env python3
"""
Compliance Dashboard and Reporting System
Comprehensive compliance visualization and reporting platform
"""

import json
import sqlite3
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from datetime import datetime, timedelta
import os
import sys

class ComplianceDashboard:
    def __init__(self):
        self.compliance_base = "/opt/compliance_management"
        self.db_path = f"{self.compliance_base}/data/database/compliance_management.db"
        self.dashboard_dir = f"{self.compliance_base}/reporting/dashboard"
        self.reports_dir = f"{self.compliance_base}/reporting/executive"
        os.makedirs(self.dashboard_dir, exist_ok=True)
        os.makedirs(self.reports_dir, exist_ok=True)
    
    def load_compliance_data(self):
        """Load compliance assessment data from database"""
        conn = sqlite3.connect(self.db_path)
        
        # Load compliance assessments with framework details
        assessments_query = """
        SELECT 
            ca.assessment_id,
            ca.framework_id,
            cf.framework_name,
            ca.assessment_type,
            ca.assessment_date,
            ca.overall_compliance_score,
            ca.compliance_status,
            ca.assessor
        FROM compliance_assessments ca
        JOIN compliance_frameworks cf ON ca.framework_id = cf.framework_id
        WHERE ca.status = 'ACTIVE'
        ORDER BY ca.assessment_date DESC
        """
        
        assessments_df = pd.read_sql_query(assessments_query, conn)
        
        # Load assessment results
        results_query = """
        SELECT 
            ar.assessment_id,
            ar.requirement_id,
            ar.compliance_status,
            ar.compliance_score,
            ar.evidence_collected
        FROM assessment_results ar
        """
        
        results_df = pd.read_sql_query(results_query, conn)
        
        # Load controls data
        controls_query = """
        SELECT 
            control_id,
            control_name,
            control_type,
            implementation_status,
            effectiveness_rating
        FROM controls
        """
        
        controls_df = pd.read_sql_query(controls_query, conn)
        
        conn.close()
        
        return assessments_df, results_df, controls_df
    
    def calculate_compliance_metrics(self, assessments_df, results_df, controls_df):
        """Calculate comprehensive compliance metrics"""
        metrics = {}
        
        # Overall compliance metrics
        metrics['total_assessments'] = len(assessments_df)
        metrics['frameworks_assessed'] = assessments_df['framework_id'].nunique() if not assessments_df.empty else 0
        
        # Compliance status distribution
        if not assessments_df.empty:
            status_counts = assessments_df['compliance_status'].value_counts()
            metrics['compliant_assessments'] = status_counts.get('COMPLIANT', 0)
            metrics['partially_compliant'] = status_counts.get('PARTIALLY_COMPLIANT', 0)
            metrics['non_compliant'] = status_counts.get('NON_COMPLIANT', 0)
            
            # Average compliance score
            metrics['avg_compliance_score'] = assessments_df['overall_compliance_score'].mean()
            metrics['min_compliance_score'] = assessments_df['overall_compliance_score'].min()
            metrics['max_compliance_score'] = assessments_df['overall_compliance_score'].max()
        else:
            metrics.update({
                'compliant_assessments': 0,
                'partially_compliant': 0,
                'non_compliant': 0,
                'avg_compliance_score': 0,
                'min_compliance_score': 0,
                'max_compliance_score': 0
            })
        
        # Framework-specific metrics
        framework_metrics = {}
        if not assessments_df.empty:
            for framework in assessments_df['framework_id'].unique():
                framework_data = assessments_df[assessments_df['framework_id'] == framework]
                framework_metrics[framework] = {
                    'assessments': len(framework_data),
                    'avg_score': framework_data['overall_compliance_score'].mean(),
                    'latest_status': framework_data.iloc[0]['compliance_status'] if not framework_data.empty else 'Unknown'
                }
        
        metrics['framework_metrics'] = framework_metrics
        
        # Controls metrics
        if not controls_df.empty:
            metrics['total_controls'] = len(controls_df)
            metrics['implemented_controls'] = len(controls_df[controls_df['implementation_status'] == 'IMPLEMENTED'])
            metrics['avg_control_effectiveness'] = controls_df['effectiveness_rating'].mean()
        else:
            metrics.update({
                'total_controls': 0,
                'implemented_controls': 0,
                'avg_control_effectiveness': 0
            })
        
        # Requirement-level metrics
        if not results_df.empty:
            metrics['total_requirements'] = len(results_df)
            req_status_counts = results_df['compliance_status'].value_counts()
            metrics['compliant_requirements'] = req_status_counts.get('COMPLIANT', 0)
            metrics['non_compliant_requirements'] = req_status_counts.get('NON_COMPLIANT', 0)
        else:
            metrics.update({
                'total_requirements': 0,
                'compliant_requirements': 0,
                'non_compliant_requirements': 0
            })
        
        return metrics
    
    def create_compliance_dashboard(self):
        """Create comprehensive compliance dashboard"""
        # Load data
        assessments_df, results_df, controls_df = self.load_compliance_data()
        metrics = self.calculate_compliance_metrics(assessments_df, results_df, controls_df)
        
        # Create dashboard figure
        fig = plt.figure(figsize=(16, 12))
        fig.suptitle('Enterprise Compliance Dashboard', fontsize=18, fontweight='bold')
        
        # 1. Overall Compliance Status (Pie Chart)
        ax1 = plt.subplot(2, 3, 1)
        if metrics['total_assessments'] > 0:
            status_counts = [metrics['compliant_assessments'], 
                           metrics['partially_compliant'], 
                           metrics['non_compliant']]
            status_labels = ['Compliant', 'Partially Compliant', 'Non-Compliant']
            colors = ['green', 'yellow', 'red']
            
            ax1.pie(status_counts, labels=status_labels, colors=colors, autopct='%1.1f%%')
            ax1.set_title('Overall Compliance Status')
        else:
            ax1.text(0.5, 0.5, 'No Assessment Data', ha='center', va='center', transform=ax1.transAxes)
            ax1.set_title('Overall Compliance Status')
        
        # 2. Framework Compliance Scores (Bar Chart)
        ax2 = plt.subplot(2, 3, 2)
        if metrics['framework_metrics']:
            frameworks = list(metrics['framework_metrics'].keys())
            scores = [metrics['framework_metrics'][fw]['avg_score'] for fw in frameworks]
            
            bars = ax2.bar(frameworks, scores)
            ax2.set_title('Compliance Scores by Framework')
            ax2.set_ylabel('Compliance Score (%)')
            ax2.set_ylim(0, 100)
            
            # Color bars based on score
            for bar, score in zip(bars, scores):
                if score >= 90:
                    bar.set_color('green')
                elif score >= 70:
                    bar.set_color('yellow')
                else:
                    bar.set_color('red')
            
            plt.xticks(rotation=45)
        else:
            ax2.text(0.5, 0.5, 'No Framework Data', ha='center', va='center', transform=ax2.transAxes)
            ax2.set_title('Compliance Scores by Framework')
        
        # 3. Controls Implementation Status
        ax3 = plt.subplot(2, 3, 3)
        if metrics['total_controls'] > 0:
            implemented = metrics['implemented_controls']
            not_implemented = metrics['total_controls'] - implemented
            
            ax3.pie([implemented, not_implemented], 
                   labels=['Implemented', 'Not Implemented'],
                   colors=['green', 'red'],
                   autopct='%1.1f%%')
            ax3.set_title('Controls Implementation Status')
        else:
            ax3.text(0.5, 0.5, 'No Controls Data', ha='center', va='center', transform=ax3.transAxes)
            ax3.set_title('Controls Implementation Status')
        
        # 4. Requirements Compliance Distribution
        ax4 = plt.subplot(2, 3, 4)
        if not results_df.empty:
            req_status_counts = results_df['compliance_status'].value_counts()
            ax4.bar(req_status_counts.index, req_status_counts.values)
            ax4.set_title('Requirements Compliance Distribution')
            ax4.set_ylabel('Number of Requirements')
            plt.xticks(rotation=45)
        else:
            ax4.text(0.5, 0.5, 'No Requirements Data', ha='center', va='center', transform=ax4.transAxes)
            ax4.set_title('Requirements Compliance Distribution')
        
        # 5. Key Metrics Summary
        ax5 = plt.subplot(2, 3, 5)
        ax5.axis('off')
        
        metrics_text = f"""
        KEY COMPLIANCE METRICS
        ======================
        
        Total Assessments: {metrics['total_assessments']}
        Frameworks Assessed: {metrics['frameworks_assessed']}
        
        Compliant: {metrics['compliant_assessments']}
        Partially Compliant: {metrics['partially_compliant']}
        Non-Compliant: {metrics['non_compliant']}
        
        Avg Compliance Score: {metrics['avg_compliance_score']:.1f}%
        
        Total Controls: {metrics['total_controls']}
        Implemented: {metrics['implemented_controls']}
        
        Total Requirements: {metrics['total_requirements']}
        Compliant Req: {metrics['compliant_requirements']}
        """
        
        ax5.text(0.1, 0.9, metrics_text, transform=ax5.transAxes, 
                 fontsize=9, verticalalignment='top', fontfamily='monospace')
        
        # 6. Compliance Risk Assessment
        ax6 = plt.subplot(2, 3, 6)
        if metrics['total_assessments'] > 0:
            # Calculate risk levels based on compliance scores
            risk_levels = []
            
            for framework, data in metrics['framework_metrics'].items():
                score = data['avg_score']
                if score >= 90:
                    risk_levels.append('Low')
                elif score >= 70:
                    risk_levels.append('Medium')
                else:
                    risk_levels.append('High')
            
            if risk_levels:
                risk_counts = pd.Series(risk_levels).value_counts()
                colors = []
                for level in risk_counts.index:
                    if level == 'Low':
                        colors.append('green')
                    elif level == 'Medium':
                        colors.append('yellow')
                    else:
                        colors.append('red')
                
                ax6.pie(risk_counts.values, labels=risk_counts.index, 
                       colors=colors, autopct='%1.1f%%')
                ax6.set_title('Compliance Risk Assessment')
            else:
                ax6.text(0.5, 0.5, 'No Risk Data', ha='center', va='center', transform=ax6.transAxes)
                ax6.set_title('Compliance Risk Assessment')
        else:
            ax6.text(0.5, 0.5, 'No Risk Data', ha='center', va='center', transform=ax6.transAxes)
            ax6.set_title('Compliance Risk Assessment')
        
        plt.tight_layout()
        
        # Save dashboard
        dashboard_file = f"{self.dashboard_dir}/compliance_dashboard_{datetime.now().strftime('%Y%m%d_%H%M%S')}.png"
        plt.savefig(dashboard_file, dpi=300, bbox_inches='tight')
        plt.close()
        
        print(f"Compliance dashboard saved: {dashboard_file}")
        return dashboard_file, metrics
    
    def generate_executive_summary(self, metrics):
        """Generate executive summary report"""
        summary_file = f"{self.reports_dir}/executive_summary_{datetime.now().strftime('%Y%m%d_%H%M%S')}.txt"
        
        with open(summary_file, 'w') as f:
            f.write("=" * 60 + "\n")
            f.write("EXECUTIVE COMPLIANCE SUMMARY\n")
            f.write("=" * 60 + "\n\n")
            
            f.write(f"Report Date: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n")
            
            f.write("COMPLIANCE PORTFOLIO OVERVIEW:\n")
            f.write("-" * 30 + "\n")
            f.write(f"Total Compliance Assessments: {metrics['total_assessments']}\n")
            f.write(f"Frameworks Under Assessment: {metrics['frameworks_assessed']}\n")
            
            if metrics['total_assessments'] > 0:
                compliance_rate = (metrics['compliant_assessments']/metrics['total_assessments']*100)
                f.write(f"Overall Compliance Rate: {compliance_rate:.1f}%\n")
            else:
                f.write("Overall Compliance Rate: N/A\n")
            
            f.write(f"Average Compliance Score: {metrics['avg_compliance_score']:.1f}%\n\n")
            
            f.write("COMPLIANCE STATUS BREAKDOWN:\n")
            f.write("-" * 28 + "\n")
            
            if metrics['total_assessments'] > 0:
                f.write(f"Fully Compliant: {metrics['compliant_assessments']} ({(metrics['compliant_assessments']/metrics['total_assessments']*100):.1f}%)\n")
                f.write(f"Partially Compliant: {metrics['partially_compliant']} ({(metrics['partially_compliant']/metrics['total_assessments']*100):.1f}%)\n")
                f.write(f"Non-Compliant: {metrics['non_compliant']} ({(metrics['non_compliant']/metrics['total_assessments']*100):.1f}%)\n\n")
            else:
                f.write("No assessment data available\n\n")
            
            f.write("FRAMEWORK-SPECIFIC PERFORMANCE:\n")
            f.write("-" * 31 + "\n")
            for framework, data in metrics['framework_metrics'].items():
                f.write(f"{framework}: {data['avg_score']:.1f}% ({data['latest_status']})\n")
            f.write("\n")
            
            f.write("CONTROLS IMPLEMENTATION:\n")
            f.write("-" * 24 + "\n")
            f.write(f"Total Controls: {metrics['total_controls']}\n")
            f.write(f"Implemented Controls: {metrics['implemented_controls']}\n")
            
            if metrics['total_controls'] > 0:
                impl_rate = (metrics['implemented_controls']/metrics['total_controls']*100)
                f.write(f"Implementation Rate: {impl_rate:.1f}%\n")
            else:
                f.write("Implementation Rate: N/A\n")
            
            f.write(f"Average Control Effectiveness: {metrics['avg_control_effectiveness']:.1f}/10\n\n")
            
            f.write("KEY FINDINGS:\n")
            f.write("-" * 13 + "\n")
            
            # Generate findings based on metrics
            if metrics['non_compliant'] > 0:
                f.write(f"• {metrics['non_compliant']} non-compliant assessments require immediate attention\n")
            
            if metrics['avg_compliance_score'] < 80:
                f.write(f"• Overall compliance score ({metrics['avg_compliance_score']:.1f}%) is below target threshold\n")
            
            if metrics['implemented_controls'] < metrics['total_controls']:
                missing_controls = metrics['total_controls'] - metrics['implemented_controls']
                f.write(f"• {missing_controls} controls are not yet implemented\n")
            
            f.write("\nRECOMMENDATIONS:\n")
            f.write("-" * 16 + "\n")
            f.write("• Prioritize remediation of non-compliant frameworks\n")
            f.write("• Implement missing controls to improve overall posture\n")
            f.write("• Conduct regular compliance assessments and monitoring\n")
            f.write("• Enhance compliance training and awareness programs\n")
            f.write("• Consider third-party compliance validation for critical frameworks\n")
        
        print(f"Executive summary generated: {summary_file}")
        return summary_file

def main():
    dashboard = ComplianceDashboard()
    
    if len(sys.argv) > 1:
        command = sys.argv[1]
        
        if command == "dashboard":
            print("Generating compliance dashboard...")
            dashboard_file, metrics = dashboard.create_compliance_dashboard()
            print(f"Dashboard generated: {dashboard_file}")
            
        elif command == "executive":
            print("Generating executive summary...")
            assessments_df, results_df, controls_df = dashboard.load_compliance_data()
            metrics = dashboard.calculate_compliance_metrics(assessments_df, results_df, controls_df)
            summary_file = dashboard.generate_executive_summary(metrics)
            print(f"Executive summary generated: {summary_file}")
            
        elif command == "all":
            print("Generating all compliance reports...")
            
            # Generate dashboard
            dashboard_file, metrics = dashboard.create_compliance_dashboard()
            print(f"Dashboard: {dashboard_file}")
            
            # Generate executive summary
            summary_file = dashboard.generate_executive_summary(metrics)
            print(f"Executive Summary: {summary_file}")
            
        else:
            print("Unknown command. Use: dashboard, executive, or all")
            sys.exit(1)
    else:
        print("Usage: python3 compliance_dashboard.py {dashboard|executive|all}")
        sys.exit(1)

if __name__ == "__main__":
    main()
EOF

# Make the dashboard script executable
chmod +x /opt/compliance_management/scripts/compliance_dashboard.py
```

### Step 3: Generate Compliance Reports and Dashboards

```bash
# Navigate to the scripts directory
cd /opt/compliance_management/scripts

# Generate compliance dashboard
echo "Generating compliance dashboard..."
python3 compliance_dashboard.py dashboard

# Generate executive summary
echo "Generating executive summary..."
python3 compliance_dashboard.py executive

# Generate all reports
echo "Generating all compliance reports..."
python3 compliance_dashboard.py all
```

### Step 4: Create a Comprehensive Compliance Summary

```bash
# Create a comprehensive compliance summary script
cat > /opt/compliance_management/scripts/compliance_summary.sh << 'EOF'
#!/bin/bash
# Comprehensive Compliance Summary

COMPLIANCE_BASE="/opt/compliance_management"
DB_FILE="$COMPLIANCE_BASE/data/database/compliance_management.db"

echo "=========================================="
echo "COMPREHENSIVE COMPLIANCE SUMMARY"
echo "=========================================="
echo "Generated: $(date)"
echo ""

# Compliance Assessment Summary
echo "COMPLIANCE ASSESSMENT SUMMARY:"
echo "------------------------------"
sqlite3 "$DB_FILE" << EOSQL
SELECT 
    'Total Assessments: ' || COUNT(*) as summary
FROM compliance_assessments 
WHERE status = 'ACTIVE';

SELECT 
    'Compliant Assessments: ' || COUNT(*) as summary
FROM compliance_assessments 
WHERE status = 'ACTIVE' AND compliance_status = 'COMPLIANT';

SELECT 
    'Partially Compliant: ' || COUNT(*) as summary
FROM compliance_assessments 
WHERE status = 'ACTIVE' AND compliance_status = 'PARTIALLY_COMPLIANT';

SELECT 
    'Non-Compliant: ' || COUNT(*) as summary
FROM compliance_assessments 
WHERE status = 'ACTIVE' AND compliance_status = 'NON_COMPLIANT';

SELECT 
    'Average Compliance Score: ' || ROUND(AVG(overall_compliance_score), 2) || '%' as summary
FROM compliance_assessments 
WHERE status = 'ACTIVE' AND overall_compliance_score IS NOT NULL;
EOSQL

echo ""

# Framework Performance
echo "FRAMEWORK PERFORMANCE:"
echo "----------------------"
sqlite3 "$DB_FILE" << EOSQL
.mode column
.headers on
SELECT 
    cf.framework_name as Framework,
    ca.compliance_status as Status,
    ca.overall_compliance_score as Score,
    ca.assessment_date as Date
FROM compliance_assessments ca
JOIN compliance_frameworks cf ON ca.framework_id = cf.framework_id
WHERE ca.status = 'ACTIVE'
ORDER BY ca.overall_compliance_score DESC;
EOSQL

echo ""

# Controls Summary
echo "CONTROLS SUMMARY:"
echo "-----------------"
sqlite3 "$DB_FILE" << EOSQL
SELECT 
    'Total Controls: ' || COUNT(*) as summary
FROM controls;

SELECT 
    'Implemented Controls: ' || COUNT(*) as summary
FROM controls 
WHERE implementation_status = 'IMPLEMENTED';

SELECT 
    'Average Effectiveness: ' || ROUND(AVG(effectiveness_rating), 2) || '/10' as summary
FROM controls 
WHERE effectiveness_rating IS NOT NULL;
EOSQL

echo ""

# Recent Activity
echo "RECENT COMPLIANCE ACTIVITY:"
echo "---------------------------"
sqlite3 "$DB_FILE" << EOSQL
.mode column
.headers on
SELECT 
    ca.assessment_date as Date,
    cf.framework_name as Framework,
    ca.compliance_status as Status,
    ca.assessor as Assessor
FROM compliance_assessments ca
JOIN compliance_frameworks cf ON ca.framework_id = cf.framework_id
WHERE ca.status = 'ACTIVE'
ORDER BY ca.assessment_date DESC
LIMIT 5;
EOSQL

echo ""

# Non-Compliant Requirements
echo "NON-COMPLIANT REQUIREMENTS:"
echo "---------------------------"
sqlite3 "$DB_FILE" << EOSQL
.mode column
.headers on
SELECT 
    ar.requirement_id as Requirement,
    ar.compliance_status as Status,
    ar.evidence_collected as Evidence
FROM assessment_results ar
WHERE ar.compliance_status = 'NON_COMPLIANT'
ORDER BY ar.requirement_id
LIMIT 10;
EOSQL

echo ""
echo "=========================================="
EOF

# Make the summary script executable
chmod +x /opt/compliance_management/scripts/compliance_summary.sh

# Run the compliance summary
./compliance_summary.sh
```

### Step 5: Review All Compliance Reports

```bash
# View generated dashboards and reports
echo "=== GENERATED COMPLIANCE REPORTS ==="
ls -la /opt/compliance_management/reporting/

# View dashboard files
echo "=== COMPLIANCE DASHBOARDS ==="
ls -la /opt/compliance_management/reporting/dashboard/

# View executive reports
echo "=== EXECUTIVE REPORTS ==="
ls -la /opt/compliance_management/reporting/executive/

# Display the latest executive summary
latest_summary=$(ls -t /opt/compliance_management/reporting/executive/executive_summary_*.txt | head -1)
if [ -n "$latest_summary" ]; then
    echo "=== LATEST EXECUTIVE SUMMARY ==="
    cat "$latest_summary"
fi
```

### Questions for Exercise 3:

1. **Dashboard Design**: What key metrics should be included in an executive compliance dashboard?

2. **Stakeholder Communication**: How would you tailor compliance reports for different audiences (executives, auditors, technical teams)?

3. **Trend Analysis**: What compliance trends would be most valuable to track over time?

4. **Automation Benefits**: How does automated reporting improve compliance management effectiveness?

---

## Lab Completion and Assessment

### Lab Deliverables

Please complete the following deliverables and submit them for assessment:

1. **Compliance Database**: Export your compliance management database
```bash
# Export the database
sqlite3 /opt/compliance_management/data/database/compliance_management.db .dump > compliance_database_export.sql
```

2. **Compliance Assessment Reports**: Package your assessment reports
```bash
# Package assessment reports
tar -czf compliance_assessment_reports.tar.gz /opt/compliance_management/reporting/assessments/
```

3. **Audit Trail Analysis**: Collect your audit trail analysis results
```bash
# Package audit analysis
tar -czf audit_trail_analysis.tar.gz /opt/compliance_management/audits/
```

4. **Compliance Dashboard**: Save your compliance dashboard and reports
```bash
# Package dashboard and executive reports
tar -czf compliance_dashboard_reports.tar.gz /opt/compliance_management/reporting/dashboard/ /opt/compliance_management/reporting/executive/
```

5. **Final Compliance Summary**: Generate your final compliance summary
```bash
cd /opt/compliance_management/scripts
./compliance_summary.sh > final_compliance_summary.txt
```

### Self-Assessment Questions

1. **Compliance Framework Implementation**:
   - How effective is your automated compliance assessment system?
   - What improvements would you make to the compliance checking logic?

2. **Audit Trail Management**:
   - How comprehensive is your audit trail collection and analysis?
   - What additional audit events would enhance compliance monitoring?

3. **Compliance Reporting**:
   - How well do your reports communicate compliance status to different stakeholders?
   - What additional visualizations or metrics would improve the reports?

4. **Integration and Automation**:
   - How well do the different compliance components work together?
   - What automation improvements would enhance the overall system?

### Reflection Questions

1. **Practical Application**: How would you implement these compliance management techniques in a real organization?

2. **Regulatory Alignment**: How well do your automated checks align with actual regulatory requirements?

3. **Scalability**: How would you scale these solutions for a large enterprise with multiple business units?

4. **Continuous Improvement**: How would you continuously improve and update your compliance management system?

### Next Steps

After completing this lab, consider exploring:

1. **Advanced Compliance Automation**: Machine learning approaches to compliance monitoring
2. **Enterprise Integration**: Connecting with existing GRC platforms and business systems
3. **Regulatory Updates**: Staying current with evolving compliance requirements
4. **Compliance Metrics**: Advanced analytics and predictive compliance modeling

---

## Troubleshooting Guide

### Common Issues and Solutions

1. **Database Connection Issues**:
   - Verify SQLite installation and file permissions
   - Check database file integrity and schema
   - Recreate database if corrupted

2. **Python Script Errors**:
   - Verify all required libraries are installed
   - Check Python version compatibility
   - Review error messages for missing dependencies

3. **Audit Configuration Issues**:
   - Verify auditd service is running
   - Check audit rule syntax and permissions
   - Review system log files for error messages

4. **Dashboard Generation Problems**:
   - Verify matplotlib and visualization libraries
   - Check data availability in database
   - Review Python script permissions and paths

### Getting Help

If you encounter issues during the lab:

1. Review the error messages carefully
2. Check the troubleshooting guide above
3. Verify all prerequisites are installed and configured
4. Ask your instructor for assistance
5. Collaborate with classmates (where appropriate)

---

**Congratulations on completing the Compliance Management and Reporting lab! You have gained comprehensive hands-on experience with modern compliance management techniques using Linux tools and methodologies. This completes your GRC101 Linux lab series, providing you with practical skills in governance, risk management, and compliance implementation.**

