# Week 4 Linux Lab: Compliance Management and Reporting
## Instructor Guide

**International Cybersecurity and Digital Forensics Academy (ICDFA)**  
**Course: GRC101 - Introduction to Governance, Risk, and Compliance**  
**Lab Duration: 3 hours**  
**Difficulty Level: Advanced**

---

## Lab Overview

This comprehensive lab focuses on implementing enterprise compliance management using Linux tools and methodologies. Students will learn to create automated compliance monitoring systems, implement audit trail management, develop compliance reporting dashboards, and build comprehensive compliance assessment frameworks. The lab emphasizes practical implementation of modern compliance frameworks including SOX, GDPR, HIPAA, PCI DSS, and ISO 27001.

### Learning Objectives

By the end of this lab, students will be able to:
1. Implement automated compliance monitoring and assessment systems
2. Create comprehensive audit trail management and log analysis
3. Develop compliance reporting and dashboard mechanisms
4. Build policy compliance verification and enforcement tools
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

### Required Software and Tools
- Linux OS (Ubuntu 22.04 LTS recommended)
- Python 3.x with compliance analysis libraries (pandas, numpy, matplotlib)
- Database systems (SQLite, MySQL/PostgreSQL)
- Log analysis tools (rsyslog, logrotate, auditd)
- System monitoring tools (systemd, cron, systemctl)
- Security scanning tools (lynis, chkrootkit, rkhunter)
- Document generation tools (pandoc, wkhtmltopdf)
- Compliance frameworks and standards documentation

### Pre-Lab Preparation
1. Install compliance monitoring and audit tools
2. Set up comprehensive logging and audit systems
3. Create compliance policy templates and frameworks
4. Prepare compliance assessment databases and schemas
5. Configure automated compliance checking infrastructure

### Installation Commands
```bash
# Update system and install base tools
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

# Install additional utilities
sudo apt install -y jq xmlstarlet csvkit curl wget git
```

---

## Exercise 1: Compliance Framework Implementation (90 minutes)

### Instructor Notes
This exercise teaches students to implement a comprehensive compliance framework using Linux tools. Focus on automated compliance assessment, policy enforcement, and regulatory mapping. Emphasize the integration of multiple compliance standards and the importance of continuous compliance monitoring.

### Learning Outcomes
- Implement automated compliance assessment frameworks
- Create policy compliance verification systems
- Develop regulatory mapping and cross-reference tools
- Build compliance evidence collection mechanisms
- Generate comprehensive compliance reports and documentation

### Setup Instructions
1. Create compliance framework database schemas
2. Set up automated policy compliance checking
3. Implement regulatory requirement mapping
4. Configure compliance evidence collection systems
5. Prepare compliance assessment templates and workflows

### Step-by-Step Walkthrough

#### Part A: Compliance Framework Infrastructure Setup
```bash
# Create comprehensive compliance management directory structure
sudo mkdir -p /opt/compliance_management/{frameworks,policies,assessments,audits,reporting,evidence}
sudo mkdir -p /opt/compliance_management/frameworks/{sox,gdpr,hipaa,pci_dss,iso27001,nist}
sudo mkdir -p /opt/compliance_management/policies/{security,privacy,operational,technical}
sudo mkdir -p /opt/compliance_management/assessments/{automated,manual,continuous,periodic}
sudo mkdir -p /opt/compliance_management/audits/{internal,external,logs,trails}
sudo mkdir -p /opt/compliance_management/evidence/{documents,logs,screenshots,configurations}

# Set up proper permissions
sudo chown -R root:compliance-admin /opt/compliance_management
sudo chmod -R 750 /opt/compliance_management

# Create compliance management groups
sudo groupadd compliance-admin
sudo groupadd compliance-auditor
sudo groupadd compliance-analyst
sudo groupadd policy-owner
```

#### Part B: Compliance Database Implementation
Students will create a comprehensive compliance database to store and manage compliance information.

```bash
#!/bin/bash
# Compliance Management Database Setup Script
# File: /opt/compliance_management/scripts/setup_compliance_database.sh

COMPLIANCE_BASE="/opt/compliance_management"
DB_DIR="$COMPLIANCE_BASE/data/database"
SCRIPTS_DIR="$COMPLIANCE_BASE/scripts"

mkdir -p "$DB_DIR"
mkdir -p "$SCRIPTS_DIR"

# Create SQLite database for compliance management
sqlite3 "$DB_DIR/compliance_management.db" << 'EOF'
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

-- Create Audit Trails table
CREATE TABLE IF NOT EXISTS audit_trails (
    trail_id TEXT PRIMARY KEY,
    event_timestamp DATETIME NOT NULL,
    event_type TEXT NOT NULL,
    event_category TEXT NOT NULL,
    user_id TEXT,
    system_component TEXT,
    event_description TEXT NOT NULL,
    event_outcome TEXT,
    source_ip TEXT,
    affected_resource TEXT,
    compliance_relevance TEXT,
    retention_period INTEGER DEFAULT 2555, -- 7 years in days
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP
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
('PCI_3.4', 'PCI_DSS', '3.4', 'Render PAN Unreadable', 'Primary account numbers must be rendered unreadable', 'Data Protection', 'CRITICAL', 'Implement strong cryptography and security protocols', 'Test encryption implementation and key management', datetime('now'));

-- Insert sample policies
INSERT INTO policies VALUES 
('POL_001', 'Information Security Policy', 'Security', 'Information Security', 'Comprehensive information security policy', 'CISO', '2024-01-01', '2024-01-01', '2025-01-01', 'ACTIVE', '/opt/compliance_management/policies/security/info_sec_policy.pdf', datetime('now'), datetime('now')),
('POL_002', 'Data Privacy Policy', 'Privacy', 'Data Protection', 'Data privacy and protection policy', 'DPO', '2024-01-01', '2024-01-01', '2025-01-01', 'ACTIVE', '/opt/compliance_management/policies/privacy/data_privacy_policy.pdf', datetime('now'), datetime('now')),
('POL_003', 'Access Control Policy', 'Security', 'Access Management', 'User access control and management policy', 'IT Security Manager', '2024-01-01', '2024-01-01', '2025-01-01', 'ACTIVE', '/opt/compliance_management/policies/security/access_control_policy.pdf', datetime('now'), datetime('now'));

-- Insert sample controls
INSERT INTO controls VALUES 
('CTRL_001', 'Multi-Factor Authentication', 'Technical', 'Access Control', 'Implement MFA for all privileged accounts', 'IMPLEMENTED', 'IT Security Team', '2024-01-15', 'Monthly', '2024-01-15', 'PASS', 9, datetime('now'), datetime('now')),
('CTRL_002', 'Data Encryption at Rest', 'Technical', 'Data Protection', 'Encrypt sensitive data stored in databases and file systems', 'IMPLEMENTED', 'Database Team', '2024-01-10', 'Quarterly', '2024-01-10', 'PASS', 8, datetime('now'), datetime('now')),
('CTRL_003', 'Security Awareness Training', 'Administrative', 'Human Resources', 'Mandatory security awareness training for all employees', 'IMPLEMENTED', 'HR Department', '2024-01-05', 'Annually', '2024-01-05', 'PASS', 7, datetime('now'), datetime('now'));

EOF

echo "Compliance management database created successfully"
```

#### Part C: Automated Compliance Assessment Engine
```bash
#!/bin/bash
# Automated Compliance Assessment Engine
# File: /opt/compliance_management/scripts/compliance_assessment_engine.sh

COMPLIANCE_BASE="/opt/compliance_management"
DB_FILE="$COMPLIANCE_BASE/data/database/compliance_management.db"
ASSESSMENT_LOG="$COMPLIANCE_BASE/assessments/logs/assessment.log"
REPORTS_DIR="$COMPLIANCE_BASE/reporting/assessments"
EVIDENCE_DIR="$COMPLIANCE_BASE/evidence"

mkdir -p "$(dirname "$ASSESSMENT_LOG")"
mkdir -p "$REPORTS_DIR"
mkdir -p "$EVIDENCE_DIR"

# Function to perform automated system compliance checks
perform_system_compliance_check() {
    local framework=$1
    local assessment_id=$2
    local check_type=$3
    
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
        "ISO27001")
            perform_iso27001_compliance_check "$assessment_id"
            ;;
        *)
            echo "Unknown framework: $framework"
            return 1
            ;;
    esac
}

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
    sqlite3 "$DB_FILE" << EOF
UPDATE compliance_assessments 
SET overall_compliance_score = $compliance_percentage,
    compliance_status = CASE 
        WHEN $compliance_percentage >= 90 THEN 'COMPLIANT'
        WHEN $compliance_percentage >= 70 THEN 'PARTIALLY_COMPLIANT'
        ELSE 'NON_COMPLIANT'
    END
WHERE assessment_id = '$assessment_id';
EOF

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
    sqlite3 "$DB_FILE" << EOF
UPDATE compliance_assessments 
SET overall_compliance_score = $compliance_percentage,
    compliance_status = CASE 
        WHEN $compliance_percentage >= 90 THEN 'COMPLIANT'
        WHEN $compliance_percentage >= 70 THEN 'PARTIALLY_COMPLIANT'
        ELSE 'NON_COMPLIANT'
    END
WHERE assessment_id = '$assessment_id';
EOF

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
    sqlite3 "$DB_FILE" << EOF
UPDATE compliance_assessments 
SET overall_compliance_score = $compliance_percentage,
    compliance_status = CASE 
        WHEN $compliance_percentage >= 90 THEN 'COMPLIANT'
        WHEN $compliance_percentage >= 70 THEN 'PARTIALLY_COMPLIANT'
        ELSE 'NON_COMPLIANT'
    END
WHERE assessment_id = '$assessment_id';
EOF

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
    
    sqlite3 "$DB_FILE" << EOF
INSERT INTO assessment_results (
    result_id, assessment_id, requirement_id, compliance_status, 
    compliance_score, evidence_collected, testing_notes
) VALUES (
    '$result_id', '$assessment_id', '$requirement_id', '$compliance_status',
    $compliance_score, '$evidence', 'Automated system check performed'
);
EOF

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
    
    sqlite3 "$DB_FILE" << EOF
INSERT INTO compliance_assessments (
    assessment_id, framework_id, assessment_type, assessment_scope,
    assessor, assessment_date, status
) VALUES (
    '$assessment_id', '$framework_id', '$assessment_type', '$assessment_scope',
    '$assessor', '$assessment_date', 'ACTIVE'
);
EOF

    echo "$assessment_id"
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
        perform_system_compliance_check "$framework" "$assessment_id" "$assessment_type"
        
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
```

### Assessment Criteria
- Proper compliance framework implementation
- Effective automated compliance checking
- Quality of compliance assessment processes
- Comprehensive compliance reporting capabilities
- Understanding of regulatory compliance requirements

### Common Issues and Solutions
1. **Database Schema Issues**: Verify proper foreign key relationships and data integrity
2. **Compliance Check Logic**: Ensure proper validation of system configurations
3. **Evidence Collection**: Implement proper documentation and audit trail management
4. **Reporting Accuracy**: Validate compliance scoring and status calculations

---

## Exercise 2: Audit Trail Management and Log Analysis (105 minutes)

### Instructor Notes
This exercise focuses on implementing comprehensive audit trail management and log analysis systems. Students will learn to create automated log collection, analysis, and retention systems that support compliance requirements. Emphasize the importance of audit trails for regulatory compliance and incident investigation.

### Learning Outcomes
- Implement comprehensive audit trail collection and management
- Create automated log analysis and correlation systems
- Develop log retention and archival mechanisms
- Build audit trail reporting and investigation tools
- Integrate audit trails with compliance frameworks

### Setup Instructions
1. Configure comprehensive system logging and audit systems
2. Set up automated log analysis and correlation tools
3. Implement log retention and archival policies
4. Create audit trail investigation and reporting mechanisms
5. Configure compliance-specific audit trail requirements

### Step-by-Step Walkthrough

#### Part A: Comprehensive Audit System Setup
```bash
#!/bin/bash
# Comprehensive Audit Trail Management System
# File: /opt/compliance_management/scripts/audit_trail_management.sh

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
    sudo tee /etc/audit/rules.d/compliance.rules << 'EOF'
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

# Monitor network connections
-a always,exit -F arch=b64 -S socket -k network_connections
-a always,exit -F arch=b32 -S socket -k network_connections

# Monitor file deletions
-a always,exit -F arch=b64 -S unlink -S unlinkat -S rename -S renameat -k file_deletion
-a always,exit -F arch=b32 -S unlink -S unlinkat -S rename -S renameat -k file_deletion

# Monitor permission changes
-a always,exit -F arch=b64 -S chmod -S fchmod -S fchmodat -k permission_changes
-a always,exit -F arch=b32 -S chmod -S fchmod -S fchmodat -k permission_changes

# Monitor ownership changes
-a always,exit -F arch=b64 -S chown -S fchown -S fchownat -S lchown -k ownership_changes
-a always,exit -F arch=b32 -S chown -S fchown -S fchownat -S lchown -k ownership_changes
EOF

    # Restart auditd to apply new rules
    sudo systemctl restart auditd
    
    echo "Audit logging configuration completed"
}

# Function to configure log rotation and retention
configure_log_retention() {
    echo "Configuring log retention policies..."
    
    # Create compliance-specific logrotate configuration
    sudo tee /etc/logrotate.d/compliance << 'EOF'
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
EOF

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
    
    # Collect security logs
    if [ -f "/var/log/secure" ]; then
        cp /var/log/secure "$collection_dir/secure.log"
    fi
    
    # Create collection manifest
    cat > "$collection_dir/collection_manifest.txt" << EOF
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
EOF

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
        grep "Accepted" "$collection_dir/auth.log" | tail -20 >> "$analysis_file"
        echo "" >> "$analysis_file"
        
        echo "Failed Login Attempts:" >> "$analysis_file"
        grep "Failed password" "$collection_dir/auth.log" | tail -20 >> "$analysis_file"
        echo "" >> "$analysis_file"
        
        echo "Privilege Escalation Events:" >> "$analysis_file"
        grep -E "(sudo|su)" "$collection_dir/auth.log" | tail -20 >> "$analysis_file"
        echo "" >> "$analysis_file"
    fi
    
    # Analyze system audit events
    if [ -f "$collection_dir/audit.log" ]; then
        echo "SYSTEM AUDIT EVENTS ANALYSIS:" >> "$analysis_file"
        echo "=============================" >> "$analysis_file"
        echo "" >> "$analysis_file"
        
        echo "File Access Events:" >> "$analysis_file"
        grep "type=PATH" "$collection_dir/audit.log" | tail -10 >> "$analysis_file"
        echo "" >> "$analysis_file"
        
        echo "System Call Events:" >> "$analysis_file"
        grep "type=SYSCALL" "$collection_dir/audit.log" | tail -10 >> "$analysis_file"
        echo "" >> "$analysis_file"
        
        echo "User Account Events:" >> "$analysis_file"
        grep -E "(user_accounts|privilege_escalation)" "$collection_dir/audit.log" | tail -10 >> "$analysis_file"
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

# Function to archive audit logs
archive_audit_logs() {
    local archive_date=$(date +%Y%m%d)
    local archive_file="$ARCHIVE_DIR/audit_archive_$archive_date.tar.gz"
    
    echo "Archiving audit logs..."
    
    # Create archive of current logs
    tar -czf "$archive_file" \
        /var/log/audit/audit.log* \
        /var/log/auth.log* \
        /var/log/syslog* \
        2>/dev/null
    
    # Create archive manifest
    cat > "$ARCHIVE_DIR/archive_manifest_$archive_date.txt" << EOF
Audit Log Archive Manifest
==========================
Archive Date: $(date)
Archive File: audit_archive_$archive_date.tar.gz
Archive Size: $(stat -c%s "$archive_file" 2>/dev/null || echo "Unknown") bytes
Archive Hash: $(sha256sum "$archive_file" | cut -d' ' -f1)

Archived Files:
$(tar -tzf "$archive_file" 2>/dev/null | head -20)

Archive created by: $(whoami)
System: $(hostname)
EOF

    echo "Audit logs archived: $archive_file"
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
    "archive")
        archive_audit_logs
        ;;
    "full")
        echo "Performing full audit trail management cycle..."
        configure_audit_logging
        configure_log_retention
        collection_dir=$(collect_audit_logs)
        analyze_audit_logs "$collection_dir"
        archive_audit_logs
        echo "Full audit trail management cycle completed"
        ;;
    *)
        echo "Usage: $0 {configure|collect|analyze|report|archive|full} [arguments]"
        echo "  configure: Configure audit logging and retention"
        echo "  collect: Collect current audit logs"
        echo "  analyze: Analyze collected audit logs"
        echo "  report: Generate compliance audit report"
        echo "  archive: Archive audit logs"
        echo "  full: Perform complete audit trail management cycle"
        exit 1
        ;;
esac
```

### Assessment Criteria
- Proper audit trail configuration and management
- Effective log analysis and correlation techniques
- Quality of compliance-specific audit reporting
- Comprehensive log retention and archival processes
- Understanding of audit trail requirements for compliance

### Advanced Extensions
1. Integration with SIEM systems for real-time analysis
2. Machine learning for anomaly detection in audit logs
3. Automated compliance violation detection and alerting
4. Integration with external audit and compliance platforms

---

## Exercise 3: Compliance Reporting and Dashboard Creation (120 minutes)

### Instructor Notes
This advanced exercise teaches students to implement comprehensive compliance reporting and dashboard systems. Students will learn to create automated compliance reports, build interactive dashboards, and develop executive-level compliance summaries. Emphasize the importance of clear communication of compliance status to different stakeholders.

### Learning Outcomes
- Implement automated compliance reporting systems
- Create interactive compliance dashboards and visualizations
- Develop executive-level compliance summaries and presentations
- Build compliance trend analysis and forecasting tools
- Generate regulatory submission and audit documentation

### Setup Instructions
1. Install advanced reporting and visualization libraries
2. Set up dashboard frameworks and templates
3. Create compliance reporting automation systems
4. Implement data visualization and charting tools
5. Configure executive reporting and presentation systems

### Step-by-Step Walkthrough

#### Part A: Compliance Dashboard Implementation
```bash
#!/bin/bash
# Compliance Dashboard and Reporting System
# File: /opt/compliance_management/scripts/compliance_dashboard.py

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
from jinja2 import Template

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
            cr.requirement_title,
            cr.control_category,
            cr.priority_level
        FROM assessment_results ar
        JOIN compliance_requirements cr ON ar.requirement_id = cr.requirement_id
        """
        
        results_df = pd.read_sql_query(results_query, conn)
        
        # Load controls data
        controls_query = """
        SELECT 
            control_id,
            control_name,
            control_type,
            control_family,
            implementation_status,
            effectiveness_rating,
            last_test_date
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
        metrics['frameworks_assessed'] = assessments_df['framework_id'].nunique()
        
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
        fig = plt.figure(figsize=(20, 15))
        fig.suptitle('Enterprise Compliance Dashboard', fontsize=20, fontweight='bold')
        
        # 1. Overall Compliance Status (Pie Chart)
        ax1 = plt.subplot(3, 4, 1)
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
        ax2 = plt.subplot(3, 4, 2)
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
        ax3 = plt.subplot(3, 4, 3)
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
        
        # 4. Compliance Trend (Time Series)
        ax4 = plt.subplot(3, 4, 4)
        if not assessments_df.empty:
            # Convert assessment_date to datetime and sort
            assessments_df['assessment_date'] = pd.to_datetime(assessments_df['assessment_date'])
            trend_data = assessments_df.sort_values('assessment_date')
            
            ax4.plot(trend_data['assessment_date'], trend_data['overall_compliance_score'], 'o-')
            ax4.set_title('Compliance Score Trend')
            ax4.set_ylabel('Compliance Score (%)')
            ax4.tick_params(axis='x', rotation=45)
        else:
            ax4.text(0.5, 0.5, 'No Trend Data', ha='center', va='center', transform=ax4.transAxes)
            ax4.set_title('Compliance Score Trend')
        
        # 5. Requirements Compliance Distribution
        ax5 = plt.subplot(3, 4, 5)
        if not results_df.empty:
            req_status_counts = results_df['compliance_status'].value_counts()
            ax5.bar(req_status_counts.index, req_status_counts.values)
            ax5.set_title('Requirements Compliance Distribution')
            ax5.set_ylabel('Number of Requirements')
            plt.xticks(rotation=45)
        else:
            ax5.text(0.5, 0.5, 'No Requirements Data', ha='center', va='center', transform=ax5.transAxes)
            ax5.set_title('Requirements Compliance Distribution')
        
        # 6. Control Effectiveness Ratings
        ax6 = plt.subplot(3, 4, 6)
        if not controls_df.empty and 'effectiveness_rating' in controls_df.columns:
            effectiveness_data = controls_df['effectiveness_rating'].dropna()
            if not effectiveness_data.empty:
                ax6.hist(effectiveness_data, bins=10, alpha=0.7, edgecolor='black')
                ax6.axvline(effectiveness_data.mean(), color='red', linestyle='--', label='Average')
                ax6.set_title('Control Effectiveness Distribution')
                ax6.set_xlabel('Effectiveness Rating')
                ax6.set_ylabel('Number of Controls')
                ax6.legend()
            else:
                ax6.text(0.5, 0.5, 'No Effectiveness Data', ha='center', va='center', transform=ax6.transAxes)
                ax6.set_title('Control Effectiveness Distribution')
        else:
            ax6.text(0.5, 0.5, 'No Controls Data', ha='center', va='center', transform=ax6.transAxes)
            ax6.set_title('Control Effectiveness Distribution')
        
        # 7. Priority Level Analysis
        ax7 = plt.subplot(3, 4, 7)
        if not results_df.empty and 'priority_level' in results_df.columns:
            priority_counts = results_df['priority_level'].value_counts()
            ax7.pie(priority_counts.values, labels=priority_counts.index, autopct='%1.1f%%')
            ax7.set_title('Requirements by Priority Level')
        else:
            ax7.text(0.5, 0.5, 'No Priority Data', ha='center', va='center', transform=ax7.transAxes)
            ax7.set_title('Requirements by Priority Level')
        
        # 8. Control Category Distribution
        ax8 = plt.subplot(3, 4, 8)
        if not results_df.empty and 'control_category' in results_df.columns:
            category_counts = results_df['control_category'].value_counts()
            ax8.bar(category_counts.index, category_counts.values)
            ax8.set_title('Requirements by Control Category')
            ax8.set_ylabel('Number of Requirements')
            plt.xticks(rotation=45)
        else:
            ax8.text(0.5, 0.5, 'No Category Data', ha='center', va='center', transform=ax8.transAxes)
            ax8.set_title('Requirements by Control Category')
        
        # 9. Assessment Type Distribution
        ax9 = plt.subplot(3, 4, 9)
        if not assessments_df.empty:
            type_counts = assessments_df['assessment_type'].value_counts()
            ax9.pie(type_counts.values, labels=type_counts.index, autopct='%1.1f%%')
            ax9.set_title('Assessment Type Distribution')
        else:
            ax9.text(0.5, 0.5, 'No Assessment Type Data', ha='center', va='center', transform=ax9.transAxes)
            ax9.set_title('Assessment Type Distribution')
        
        # 10. Compliance Heat Map
        ax10 = plt.subplot(3, 4, 10)
        if metrics['framework_metrics']:
            frameworks = list(metrics['framework_metrics'].keys())
            scores = [metrics['framework_metrics'][fw]['avg_score'] for fw in frameworks]
            
            # Create a simple heat map representation
            heat_data = np.array(scores).reshape(1, -1)
            im = ax10.imshow(heat_data, cmap='RdYlGn', aspect='auto', vmin=0, vmax=100)
            ax10.set_xticks(range(len(frameworks)))
            ax10.set_xticklabels(frameworks, rotation=45)
            ax10.set_yticks([])
            ax10.set_title('Compliance Score Heat Map')
            
            # Add colorbar
            plt.colorbar(im, ax=ax10)
        else:
            ax10.text(0.5, 0.5, 'No Heat Map Data', ha='center', va='center', transform=ax10.transAxes)
            ax10.set_title('Compliance Score Heat Map')
        
        # 11. Key Metrics Summary
        ax11 = plt.subplot(3, 4, 11)
        ax11.axis('off')
        
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
        
        ax11.text(0.1, 0.9, metrics_text, transform=ax11.transAxes, 
                 fontsize=10, verticalalignment='top', fontfamily='monospace')
        
        # 12. Compliance Risk Assessment
        ax12 = plt.subplot(3, 4, 12)
        if metrics['total_assessments'] > 0:
            # Calculate risk levels based on compliance scores
            risk_levels = []
            risk_colors = []
            
            for framework, data in metrics['framework_metrics'].items():
                score = data['avg_score']
                if score >= 90:
                    risk_levels.append('Low')
                    risk_colors.append('green')
                elif score >= 70:
                    risk_levels.append('Medium')
                    risk_colors.append('yellow')
                else:
                    risk_levels.append('High')
                    risk_colors.append('red')
            
            risk_counts = pd.Series(risk_levels).value_counts()
            ax12.pie(risk_counts.values, labels=risk_counts.index, 
                    colors=['green' if 'Low' in risk_counts.index else None,
                           'yellow' if 'Medium' in risk_counts.index else None,
                           'red' if 'High' in risk_counts.index else None],
                    autopct='%1.1f%%')
            ax12.set_title('Compliance Risk Assessment')
        else:
            ax12.text(0.5, 0.5, 'No Risk Data', ha='center', va='center', transform=ax12.transAxes)
            ax12.set_title('Compliance Risk Assessment')
        
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
            f.write(f"Overall Compliance Rate: {(metrics['compliant_assessments']/max(metrics['total_assessments'], 1)*100):.1f}%\n")
            f.write(f"Average Compliance Score: {metrics['avg_compliance_score']:.1f}%\n\n")
            
            f.write("COMPLIANCE STATUS BREAKDOWN:\n")
            f.write("-" * 28 + "\n")
            f.write(f"Fully Compliant: {metrics['compliant_assessments']} ({(metrics['compliant_assessments']/max(metrics['total_assessments'], 1)*100):.1f}%)\n")
            f.write(f"Partially Compliant: {metrics['partially_compliant']} ({(metrics['partially_compliant']/max(metrics['total_assessments'], 1)*100):.1f}%)\n")
            f.write(f"Non-Compliant: {metrics['non_compliant']} ({(metrics['non_compliant']/max(metrics['total_assessments'], 1)*100):.1f}%)\n\n")
            
            f.write("FRAMEWORK-SPECIFIC PERFORMANCE:\n")
            f.write("-" * 31 + "\n")
            for framework, data in metrics['framework_metrics'].items():
                f.write(f"{framework}: {data['avg_score']:.1f}% ({data['latest_status']})\n")
            f.write("\n")
            
            f.write("CONTROLS IMPLEMENTATION:\n")
            f.write("-" * 24 + "\n")
            f.write(f"Total Controls: {metrics['total_controls']}\n")
            f.write(f"Implemented Controls: {metrics['implemented_controls']}\n")
            f.write(f"Implementation Rate: {(metrics['implemented_controls']/max(metrics['total_controls'], 1)*100):.1f}%\n")
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
    
    def generate_regulatory_report(self, framework):
        """Generate regulatory-specific compliance report"""
        report_file = f"{self.reports_dir}/regulatory_report_{framework}_{datetime.now().strftime('%Y%m%d_%H%M%S')}.txt"
        
        # Load framework-specific data
        conn = sqlite3.connect(self.db_path)
        
        framework_query = f"""
        SELECT 
            ca.assessment_id,
            ca.assessment_date,
            ca.overall_compliance_score,
            ca.compliance_status,
            cf.framework_name,
            cf.regulatory_body
        FROM compliance_assessments ca
        JOIN compliance_frameworks cf ON ca.framework_id = cf.framework_id
        WHERE ca.framework_id = '{framework}' AND ca.status = 'ACTIVE'
        ORDER BY ca.assessment_date DESC
        LIMIT 1
        """
        
        framework_data = pd.read_sql_query(framework_query, conn)
        
        requirements_query = f"""
        SELECT 
            ar.requirement_id,
            cr.requirement_title,
            ar.compliance_status,
            ar.compliance_score,
            ar.evidence_collected,
            ar.gaps_identified
        FROM assessment_results ar
        JOIN compliance_requirements cr ON ar.requirement_id = cr.requirement_id
        WHERE ar.assessment_id IN (
            SELECT assessment_id FROM compliance_assessments 
            WHERE framework_id = '{framework}' AND status = 'ACTIVE'
        )
        ORDER BY ar.compliance_score ASC
        """
        
        requirements_data = pd.read_sql_query(requirements_query, conn)
        conn.close()
        
        with open(report_file, 'w') as f:
            f.write("=" * 60 + "\n")
            f.write(f"REGULATORY COMPLIANCE REPORT - {framework}\n")
            f.write("=" * 60 + "\n\n")
            
            if not framework_data.empty:
                f.write("FRAMEWORK INFORMATION:\n")
                f.write("-" * 22 + "\n")
                f.write(f"Framework: {framework_data.iloc[0]['framework_name']}\n")
                f.write(f"Regulatory Body: {framework_data.iloc[0]['regulatory_body']}\n")
                f.write(f"Latest Assessment Date: {framework_data.iloc[0]['assessment_date']}\n")
                f.write(f"Overall Compliance Score: {framework_data.iloc[0]['overall_compliance_score']}%\n")
                f.write(f"Compliance Status: {framework_data.iloc[0]['compliance_status']}\n\n")
            
            if not requirements_data.empty:
                f.write("REQUIREMENTS ASSESSMENT SUMMARY:\n")
                f.write("-" * 32 + "\n")
                
                compliant_count = len(requirements_data[requirements_data['compliance_status'] == 'COMPLIANT'])
                partial_count = len(requirements_data[requirements_data['compliance_status'] == 'PARTIALLY_COMPLIANT'])
                non_compliant_count = len(requirements_data[requirements_data['compliance_status'] == 'NON_COMPLIANT'])
                total_requirements = len(requirements_data)
                
                f.write(f"Total Requirements: {total_requirements}\n")
                f.write(f"Compliant: {compliant_count} ({(compliant_count/total_requirements*100):.1f}%)\n")
                f.write(f"Partially Compliant: {partial_count} ({(partial_count/total_requirements*100):.1f}%)\n")
                f.write(f"Non-Compliant: {non_compliant_count} ({(non_compliant_count/total_requirements*100):.1f}%)\n\n")
                
                f.write("NON-COMPLIANT REQUIREMENTS:\n")
                f.write("-" * 27 + "\n")
                non_compliant_reqs = requirements_data[requirements_data['compliance_status'] == 'NON_COMPLIANT']
                
                for _, req in non_compliant_reqs.iterrows():
                    f.write(f"• {req['requirement_id']}: {req['requirement_title']}\n")
                    if pd.notna(req['gaps_identified']):
                        f.write(f"  Gap: {req['gaps_identified']}\n")
                    f.write("\n")
                
                f.write("REMEDIATION PRIORITIES:\n")
                f.write("-" * 23 + "\n")
                f.write("1. Address all non-compliant requirements immediately\n")
                f.write("2. Develop corrective action plans with timelines\n")
                f.write("3. Assign responsible parties for each remediation item\n")
                f.write("4. Schedule follow-up assessments to verify compliance\n")
                f.write("5. Update policies and procedures as necessary\n")
            
            f.write(f"\nReport Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
            f.write("=" * 60 + "\n")
        
        print(f"Regulatory report generated: {report_file}")
        return report_file

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
            _, _, _ = dashboard.load_compliance_data()
            assessments_df, results_df, controls_df = dashboard.load_compliance_data()
            metrics = dashboard.calculate_compliance_metrics(assessments_df, results_df, controls_df)
            summary_file = dashboard.generate_executive_summary(metrics)
            print(f"Executive summary generated: {summary_file}")
            
        elif command == "regulatory":
            if len(sys.argv) < 3:
                print("Usage: python3 compliance_dashboard.py regulatory <framework_id>")
                sys.exit(1)
            
            framework = sys.argv[2]
            print(f"Generating regulatory report for {framework}...")
            report_file = dashboard.generate_regulatory_report(framework)
            print(f"Regulatory report generated: {report_file}")
            
        elif command == "all":
            print("Generating all compliance reports...")
            
            # Generate dashboard
            dashboard_file, metrics = dashboard.create_compliance_dashboard()
            print(f"Dashboard: {dashboard_file}")
            
            # Generate executive summary
            summary_file = dashboard.generate_executive_summary(metrics)
            print(f"Executive Summary: {summary_file}")
            
            # Generate regulatory reports for all frameworks
            frameworks = ['SOX', 'GDPR', 'PCI_DSS', 'ISO27001']
            for framework in frameworks:
                try:
                    report_file = dashboard.generate_regulatory_report(framework)
                    print(f"Regulatory Report ({framework}): {report_file}")
                except Exception as e:
                    print(f"Error generating report for {framework}: {e}")
            
        else:
            print("Unknown command. Use: dashboard, executive, regulatory, or all")
            sys.exit(1)
    else:
        print("Usage: python3 compliance_dashboard.py {dashboard|executive|regulatory|all} [framework_id]")
        sys.exit(1)

if __name__ == "__main__":
    main()
EOF

# Make the dashboard script executable
chmod +x /opt/compliance_management/scripts/compliance_dashboard.py
```

### Assessment Criteria
- Effective compliance dashboard design and implementation
- Quality of executive reporting and communication
- Comprehensive regulatory reporting capabilities
- Proper data visualization and presentation techniques
- Understanding of stakeholder reporting requirements

### Advanced Extensions
1. Integration with business intelligence platforms
2. Real-time compliance monitoring and alerting
3. Automated regulatory submission preparation
4. Advanced analytics and predictive compliance modeling

---

## Assessment and Grading

### Comprehensive Assessment Rubric (100 points total)

#### Exercise 1: Compliance Framework Implementation (30 points)
- Database design and compliance data management (10 points)
- Automated compliance assessment processes (10 points)
- Compliance reporting and documentation (10 points)

#### Exercise 2: Audit Trail Management and Log Analysis (35 points)
- Comprehensive audit logging configuration (12 points)
- Log analysis and correlation techniques (12 points)
- Audit trail reporting and investigation (11 points)

#### Exercise 3: Compliance Reporting and Dashboard Creation (25 points)
- Dashboard design and visualization quality (10 points)
- Executive reporting and communication (8 points)
- Regulatory reporting accuracy and completeness (7 points)

#### Integration and Understanding (10 points)
- System integration effectiveness (5 points)
- Demonstration of compliance management concepts (5 points)

### Post-Lab Activities

#### Reflection Questions
1. How does automated compliance monitoring improve organizational compliance posture?
2. What are the challenges of maintaining compliance across multiple regulatory frameworks?
3. How can technology enhance the effectiveness of compliance programs?
4. What role does audit trail management play in regulatory compliance?

#### Follow-Up Assignments
1. Research emerging compliance technologies and automation tools
2. Compare Linux-based compliance solutions with commercial platforms
3. Design a comprehensive compliance program for a specific industry
4. Analyze real-world compliance failures and lessons learned

---

*This instructor guide provides comprehensive support for delivering advanced compliance management education using Linux platforms. The exercises demonstrate practical implementation of modern compliance frameworks through hands-on technical implementation and automated compliance management.*

