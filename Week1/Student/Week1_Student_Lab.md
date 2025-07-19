# Week 1 Linux Lab: GRC Frameworks and Principles
## Student Lab Manual

**International Cybersecurity and Digital Forensics Academy (ICDFA)**  
**Course: GRC101 - Introduction to Governance, Risk, and Compliance**  
**Lab Duration: 3 hours**  
**Student Name: _________________ Date: _________________**

---

## Lab Introduction

Welcome to your first hands-on GRC lab! In this lab, you will learn to use Linux operating system tools to implement practical GRC (Governance, Risk, and Compliance) frameworks. You'll discover how Linux's powerful command-line tools and security features can support organizational GRC initiatives.

### What You Will Learn
- Use Linux commands for GRC documentation and data management
- Implement governance controls using file permissions and access controls
- Create risk assessment tools and data collection methods
- Set up basic compliance monitoring systems
- Understand how Linux security features support GRC frameworks

### What You Need
- Access to a Linux system (Ubuntu 22.04 or similar)
- Basic knowledge of Linux commands
- Text editor (nano, vim, or gedit)
- Internet connection for package installation

---

## Pre-Lab Setup

Before starting the exercises, ensure your system has the required tools installed.

### Step 1: Update Your System
```bash
# Update package lists and upgrade system
sudo apt update && sudo apt upgrade -y
```

### Step 2: Install Required Tools
```bash
#Activate in Linux
sudo apt install -y software-properties-common

# Install system monitoring and security tools
sudo apt install -y htop iotop net-tools fail2ban ufw auditd pandoc tree

# Install text processing utilities
sudo apt install -y jq xmlstarlet csvkit

# Install additional security tools
sudo apt install -y rkhunter chkrootkit lynis
```

### Step 3: Verify Installation
```bash
# Check if tools are installed correctly
which htop && echo "htop installed successfully"
which auditd && echo "auditd installed successfully"
which pandoc && echo "pandoc installed successfully"
```

---

## Exercise 1: Building a Governance Documentation Framework

**Time Allocation: 45 minutes**

In this exercise, you'll create a structured documentation system for organizational governance using Linux file systems and permissions.

### Learning Objectives
- Create organized directory structures for governance documents
- Implement proper access controls for sensitive information
- Develop standardized documentation templates
- Understand the relationship between file permissions and governance

### Part A: Creating the Governance Directory Structure

1. **Create the main governance directory structure:**
```bash
# Create base directories for governance documentation
sudo mkdir -p /opt/grc/governance/{policies,procedures,standards,guidelines}
sudo mkdir -p /opt/grc/governance/{board,executive,operational}
sudo mkdir -p /opt/grc/governance/templates

# Verify the structure was created
tree /opt/grc/governance
```

2. **Set up user groups for access control:**
```bash
# Create groups for different access levels
sudo groupadd grc-admin
sudo groupadd grc-auditor
sudo groupadd grc-user

# Add yourself to the grc-user group
sudo usermod -a -G grc-user $USER

# Verify group membership
groups $USER
```

3. **Configure directory permissions:**
```bash
# Set ownership and permissions for governance directories
sudo chown -R root:grc-admin /opt/grc/governance
sudo chmod -R 750 /opt/grc/governance

# Allow grc-user group to read most directories
sudo chmod -R 755 /opt/grc/governance/policies
sudo chmod -R 755 /opt/grc/governance/procedures
```

### Part B: Creating Governance Policy Templates

1. **Create a policy template directory in your home folder:**
```bash
# Create personal workspace for governance work
mkdir -p ~/grc_workspace/templates
cd ~/grc_workspace/templates
```

2. **Create a standard policy template:**
```bash
# Create a policy template file
cat > policy_template.md << 'EOF'
# [Policy Name]

**Document Type:** Policy  
**Document ID:** POL-[XXX]  
**Version:** 1.0  
**Effective Date:** [Date]  
**Review Date:** [Date]  
**Owner:** [Department/Role]  
**Approved By:** [Authority]

## Purpose

[Describe the purpose and scope of this policy]

## Scope

[Define who and what this policy applies to]

## Policy Statement

[State the policy requirements clearly]

## Responsibilities

### [Role 1]
- [Responsibility 1]
- [Responsibility 2]

### [Role 2]
- [Responsibility 1]
- [Responsibility 2]

## Compliance

[Describe compliance requirements and consequences]

## Related Documents

- [Related Policy 1]
- [Related Procedure 1]

## Revision History

| Version | Date | Changes | Approved By |
|---------|------|---------|-------------|
| 1.0     | [Date] | Initial version | [Name] |

EOF
```

3. **Create a procedure template:**
```bash
# Create a procedure template file
cat > procedure_template.md << 'EOF'
# [Procedure Name]

**Document Type:** Procedure  
**Document ID:** PROC-[XXX]  
**Version:** 1.0  
**Effective Date:** [Date]  
**Related Policy:** [Policy ID]

## Purpose

[Explain what this procedure accomplishes]

## Prerequisites

[List any requirements before starting]

## Procedure Steps

### Step 1: [Step Name]
1. [Detailed instruction]
2. [Detailed instruction]
3. [Detailed instruction]

### Step 2: [Step Name]
1. [Detailed instruction]
2. [Detailed instruction]

## Verification

[How to verify the procedure was completed correctly]

## Troubleshooting

[Common issues and solutions]

## Records

[What records should be maintained]

EOF
```

### Part C: Implementing Document Version Control

1. **Set up a simple version control system:**
```bash
# Create version control directory
mkdir -p ~/grc_workspace/versions

# Create a script to manage document versions
cat > ~/grc_workspace/version_control.sh << 'EOF'
#!/bin/bash
# Simple document version control script

DOCUMENT=$1
VERSION_DIR="$HOME/grc_workspace/versions"

if [ -z "$DOCUMENT" ]; then
    echo "Usage: $0 <document_name>"
    exit 1
fi

# Create timestamp
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Copy document with timestamp
cp "$DOCUMENT" "$VERSION_DIR/$(basename $DOCUMENT .md)_$TIMESTAMP.md"

echo "Document versioned: $(basename $DOCUMENT .md)_$TIMESTAMP.md"
EOF

# Make the script executable
chmod +x ~/grc_workspace/version_control.sh
```

2. **Test the version control system:**
```bash
# Create a sample policy
cp ~/grc_workspace/templates/policy_template.md ~/grc_workspace/sample_policy.md

# Version the document
~/grc_workspace/version_control.sh ~/grc_workspace/sample_policy.md

# Check the versions directory
ls -la ~/grc_workspace/versions/
```

### ✅ Checkpoint 1
**Verify your work:**
- [ ] Governance directory structure created
- [ ] User groups configured
- [ ] Permissions set correctly
- [ ] Policy and procedure templates created
- [ ] Version control system working

---

## Exercise 2: Risk Assessment Data Collection System

**Time Allocation: 60 minutes**

In this exercise, you'll build a system to collect and analyze risk-related data using Linux tools.

### Learning Objectives
- Use Linux commands to gather system information for risk assessment
- Create automated scripts for data collection
- Analyze system logs for risk indicators
- Generate risk assessment reports

### Part A: Setting Up Risk Assessment Infrastructure

1. **Create risk assessment directory structure:**
```bash
# Create comprehensive risk assessment structure
mkdir -p ~/risk_assessment/{data,reports,scripts,templates}
cd ~/risk_assessment
```

2. **Create a risk assessment configuration file:**
```bash
# Create configuration file for risk assessment
cat > config/risk_config.conf << 'EOF'
# Risk Assessment Configuration
RISK_DATA_DIR="$HOME/risk_assessment/data"
RISK_REPORTS_DIR="$HOME/risk_assessment/reports"
RISK_SCRIPTS_DIR="$HOME/risk_assessment/scripts"

# Risk thresholds
CPU_THRESHOLD=80
MEMORY_THRESHOLD=85
DISK_THRESHOLD=90
FAILED_LOGIN_THRESHOLD=5

# Report settings
REPORT_FORMAT="text"
INCLUDE_RECOMMENDATIONS="yes"
EOF
```

### Part B: System Information Collection

1. **Create a comprehensive system information script:**
```bash
# Create system information collection script
cat > scripts/collect_system_info.sh << 'EOF'
#!/bin/bash
# System Information Collection for Risk Assessment

# Source configuration
source ~/risk_assessment/config/risk_config.conf

# Create data directory if it doesn't exist
mkdir -p "$RISK_DATA_DIR"

# Get current date for file naming
DATE=$(date +%Y%m%d_%H%M%S)

echo "Collecting system information for risk assessment..."

# Basic system information
echo "=== System Information ===" > "$RISK_DATA_DIR/system_info_$DATE.txt"
uname -a >> "$RISK_DATA_DIR/system_info_$DATE.txt"
echo "" >> "$RISK_DATA_DIR/system_info_$DATE.txt"

# CPU information
echo "=== CPU Information ===" >> "$RISK_DATA_DIR/system_info_$DATE.txt"
lscpu >> "$RISK_DATA_DIR/system_info_$DATE.txt"
echo "" >> "$RISK_DATA_DIR/system_info_$DATE.txt"

# Memory information
echo "=== Memory Information ===" >> "$RISK_DATA_DIR/system_info_$DATE.txt"
free -h >> "$RISK_DATA_DIR/system_info_$DATE.txt"
echo "" >> "$RISK_DATA_DIR/system_info_$DATE.txt"

# Disk usage
echo "=== Disk Usage ===" >> "$RISK_DATA_DIR/system_info_$DATE.txt"
df -h >> "$RISK_DATA_DIR/system_info_$DATE.txt"
echo "" >> "$RISK_DATA_DIR/system_info_$DATE.txt"

# Network interfaces
echo "=== Network Interfaces ===" >> "$RISK_DATA_DIR/system_info_$DATE.txt"
ip addr show >> "$RISK_DATA_DIR/system_info_$DATE.txt"
echo "" >> "$RISK_DATA_DIR/system_info_$DATE.txt"

# Running processes
echo "=== Top Processes by CPU ===" >> "$RISK_DATA_DIR/system_info_$DATE.txt"
ps aux --sort=-%cpu | head -20 >> "$RISK_DATA_DIR/system_info_$DATE.txt"

echo "System information collected: system_info_$DATE.txt"
EOF

# Make script executable
chmod +x scripts/collect_system_info.sh
```

2. **Create a security assessment script:**
```bash
# Create security-focused data collection script
cat > scripts/security_assessment.sh << 'EOF'
#!/bin/bash
# Security Assessment Data Collection

# Source configuration
source ~/risk_assessment/config/risk_config.conf

# Create data directory
mkdir -p "$RISK_DATA_DIR"
DATE=$(date +%Y%m%d_%H%M%S)

echo "Collecting security assessment data..."

# Check for failed login attempts
echo "=== Failed Login Attempts ===" > "$RISK_DATA_DIR/security_assessment_$DATE.txt"
sudo grep "Failed password" /var/log/auth.log | tail -20 >> "$RISK_DATA_DIR/security_assessment_$DATE.txt" 2>/dev/null
echo "" >> "$RISK_DATA_DIR/security_assessment_$DATE.txt"

# Check listening ports
echo "=== Listening Network Ports ===" >> "$RISK_DATA_DIR/security_assessment_$DATE.txt"
sudo netstat -tuln >> "$RISK_DATA_DIR/security_assessment_$DATE.txt"
echo "" >> "$RISK_DATA_DIR/security_assessment_$DATE.txt"

# Check for SUID files (potential security risk)
echo "=== SUID Files ===" >> "$RISK_DATA_DIR/security_assessment_$DATE.txt"
sudo find /usr -type f -perm -4000 2>/dev/null >> "$RISK_DATA_DIR/security_assessment_$DATE.txt"
echo "" >> "$RISK_DATA_DIR/security_assessment_$DATE.txt"

# Check system updates
echo "=== Available Updates ===" >> "$RISK_DATA_DIR/security_assessment_$DATE.txt"
apt list --upgradable 2>/dev/null | grep -v "WARNING" >> "$RISK_DATA_DIR/security_assessment_$DATE.txt"

echo "Security assessment completed: security_assessment_$DATE.txt"
EOF

# Make script executable
chmod +x scripts/security_assessment.sh
```

### Part C: Risk Analysis and Reporting

1. **Create a risk analysis script:**
```bash
# Create risk analysis script
cat > scripts/analyze_risks.sh << 'EOF'
#!/bin/bash
# Risk Analysis Script

# Source configuration
source ~/risk_assessment/config/risk_config.conf

# Create reports directory
mkdir -p "$RISK_REPORTS_DIR"
DATE=$(date +%Y%m%d_%H%M%S)

echo "Analyzing collected risk data..."

# Initialize risk report
REPORT_FILE="$RISK_REPORTS_DIR/risk_analysis_$DATE.txt"

echo "=== RISK ANALYSIS REPORT ===" > "$REPORT_FILE"
echo "Generated: $(date)" >> "$REPORT_FILE"
echo "System: $(hostname)" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Analyze disk usage
echo "=== DISK USAGE RISK ANALYSIS ===" >> "$REPORT_FILE"
df -h | awk 'NR>1 {
    usage = substr($5, 1, length($5)-1)
    if (usage > 90) 
        print "HIGH RISK: " $6 " is " $5 " full"
    else if (usage > 75)
        print "MEDIUM RISK: " $6 " is " $5 " full"
    else
        print "LOW RISK: " $6 " is " $5 " full"
}' >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Analyze memory usage
echo "=== MEMORY USAGE RISK ANALYSIS ===" >> "$REPORT_FILE"
MEMORY_USAGE=$(free | awk 'NR==2{printf "%.0f", $3*100/$2}')
if [ "$MEMORY_USAGE" -gt 85 ]; then
    echo "HIGH RISK: Memory usage is ${MEMORY_USAGE}%" >> "$REPORT_FILE"
elif [ "$MEMORY_USAGE" -gt 70 ]; then
    echo "MEDIUM RISK: Memory usage is ${MEMORY_USAGE}%" >> "$REPORT_FILE"
else
    echo "LOW RISK: Memory usage is ${MEMORY_USAGE}%" >> "$REPORT_FILE"
fi
echo "" >> "$REPORT_FILE"

# Analyze failed logins
echo "=== AUTHENTICATION RISK ANALYSIS ===" >> "$REPORT_FILE"
FAILED_LOGINS=$(sudo grep "Failed password" /var/log/auth.log 2>/dev/null | wc -l)
if [ "$FAILED_LOGINS" -gt 10 ]; then
    echo "HIGH RISK: $FAILED_LOGINS failed login attempts detected" >> "$REPORT_FILE"
elif [ "$FAILED_LOGINS" -gt 5 ]; then
    echo "MEDIUM RISK: $FAILED_LOGINS failed login attempts detected" >> "$REPORT_FILE"
else
    echo "LOW RISK: $FAILED_LOGINS failed login attempts detected" >> "$REPORT_FILE"
fi

echo "Risk analysis completed: $REPORT_FILE"
EOF

# Make script executable
chmod +x scripts/analyze_risks.sh
```

2. **Test your risk assessment system:**
```bash
# Run system information collection
./scripts/collect_system_info.sh

# Run security assessment
./scripts/security_assessment.sh

# Run risk analysis
./scripts/analyze_risks.sh

# View the latest risk report
ls -la reports/
cat reports/risk_analysis_*.txt | tail -20
```

### ✅ Checkpoint 2
**Verify your work:**
- [ ] Risk assessment directory structure created
- [ ] System information collection script working
- [ ] Security assessment script functional
- [ ] Risk analysis script generating reports
- [ ] Data files created in correct locations

---

## Exercise 3: Compliance Monitoring Implementation

**Time Allocation: 75 minutes**

In this exercise, you'll implement a compliance monitoring system using Linux auditing and monitoring tools.

### Learning Objectives
- Configure system auditing for compliance tracking
- Create automated compliance verification scripts
- Set up log monitoring for compliance violations
- Generate compliance reports

### Part A: System Auditing Configuration

1. **Set up the Linux audit system:**
```bash
# Create compliance monitoring directory
mkdir -p ~/compliance/{config,scripts,reports,data}
cd ~/compliance

# Check if auditd is running
sudo systemctl status auditd

# Start auditd if not running
sudo systemctl enable auditd
sudo systemctl start auditd
```

2. **Configure audit rules for compliance monitoring:**
```bash
# Create audit rules for compliance
cat > config/audit_rules.conf << 'EOF'
# Audit rules for GRC compliance monitoring

# Monitor user and group management
-w /etc/passwd -p wa -k user_management
-w /etc/group -p wa -k group_management
-w /etc/shadow -p wa -k password_changes
-w /etc/gshadow -p wa -k group_password_changes

# Monitor system configuration changes
-w /etc/ssh/sshd_config -p wa -k ssh_config
-w /etc/sudoers -p wa -k sudo_config
-w /etc/hosts -p wa -k network_config

# Monitor file permission changes on sensitive directories
-w /etc -p wa -k etc_changes
-w /var/log -p wa -k log_changes

# Monitor privileged commands
-w /usr/bin/sudo -p x -k privileged_commands
-w /usr/bin/su -p x -k privileged_commands
EOF

# Apply audit rules
sudo cp config/audit_rules.conf /etc/audit/rules.d/grc_compliance.rules
sudo systemctl restart auditd
```

3. **Verify audit configuration:**
```bash
# Check audit status
sudo auditctl -s

# List active audit rules
sudo auditctl -l

# Test audit logging by making a monitored change
sudo touch /etc/test_audit_file
sudo rm /etc/test_audit_file
```

### Part B: Compliance Check Scripts

1. **Create a password policy compliance checker:**
```bash
# Create password policy compliance script
cat > scripts/check_password_policy.sh << 'EOF'
#!/bin/bash
# Password Policy Compliance Checker

COMPLIANCE_DIR="$HOME/compliance"
REPORT_FILE="$COMPLIANCE_DIR/reports/password_policy_$(date +%Y%m%d_%H%M%S).txt"

mkdir -p "$COMPLIANCE_DIR/reports"

echo "=== PASSWORD POLICY COMPLIANCE CHECK ===" > "$REPORT_FILE"
echo "Date: $(date)" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Check password aging settings
echo "=== Password Aging Configuration ===" >> "$REPORT_FILE"
echo "PASS_MAX_DAYS setting:" >> "$REPORT_FILE"
grep "^PASS_MAX_DAYS" /etc/login.defs >> "$REPORT_FILE" 2>/dev/null || echo "Not configured" >> "$REPORT_FILE"

echo "PASS_MIN_DAYS setting:" >> "$REPORT_FILE"
grep "^PASS_MIN_DAYS" /etc/login.defs >> "$REPORT_FILE" 2>/dev/null || echo "Not configured" >> "$REPORT_FILE"

echo "PASS_WARN_AGE setting:" >> "$REPORT_FILE"
grep "^PASS_WARN_AGE" /etc/login.defs >> "$REPORT_FILE" 2>/dev/null || echo "Not configured" >> "$REPORT_FILE"

echo "" >> "$REPORT_FILE"

# Check for users with no password expiry
echo "=== Users with No Password Expiry ===" >> "$REPORT_FILE"
awk -F: '($2 != "*" && $2 != "!" && $5 == "") {print $1}' /etc/shadow >> "$REPORT_FILE"

echo "" >> "$REPORT_FILE"

# Check for accounts with empty passwords
echo "=== Accounts with Empty Passwords ===" >> "$REPORT_FILE"
awk -F: '($2 == "") {print $1}' /etc/shadow >> "$REPORT_FILE"

echo "Password policy compliance check completed: $REPORT_FILE"
EOF

# Make script executable
chmod +x scripts/check_password_policy.sh
```

2. **Create a file permissions compliance checker:**
```bash
# Create file permissions compliance script
cat > scripts/check_file_permissions.sh << 'EOF'
#!/bin/bash
# File Permissions Compliance Checker

COMPLIANCE_DIR="$HOME/compliance"
REPORT_FILE="$COMPLIANCE_DIR/reports/file_permissions_$(date +%Y%m%d_%H%M%S).txt"

mkdir -p "$COMPLIANCE_DIR/reports"

echo "=== FILE PERMISSIONS COMPLIANCE CHECK ===" > "$REPORT_FILE"
echo "Date: $(date)" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Check for world-writable files
echo "=== World-Writable Files ===" >> "$REPORT_FILE"
find /etc /usr /var -type f -perm -002 2>/dev/null | head -20 >> "$REPORT_FILE"

echo "" >> "$REPORT_FILE"

# Check for SUID files
echo "=== SUID Files ===" >> "$REPORT_FILE"
find /usr -type f -perm -4000 2>/dev/null >> "$REPORT_FILE"

echo "" >> "$REPORT_FILE"

# Check for SGID files
echo "=== SGID Files ===" >> "$REPORT_FILE"
find /usr -type f -perm -2000 2>/dev/null >> "$REPORT_FILE"

echo "" >> "$REPORT_FILE"

# Check critical file permissions
echo "=== Critical File Permissions ===" >> "$REPORT_FILE"
echo "Checking /etc/passwd permissions:" >> "$REPORT_FILE"
ls -l /etc/passwd >> "$REPORT_FILE"

echo "Checking /etc/shadow permissions:" >> "$REPORT_FILE"
ls -l /etc/shadow >> "$REPORT_FILE"

echo "Checking /etc/group permissions:" >> "$REPORT_FILE"
ls -l /etc/group >> "$REPORT_FILE"

echo "File permissions compliance check completed: $REPORT_FILE"
EOF

# Make script executable
chmod +x scripts/check_file_permissions.sh
```

3. **Create a system configuration compliance checker:**
```bash
# Create system configuration compliance script
cat > scripts/check_system_config.sh << 'EOF'
#!/bin/bash
# System Configuration Compliance Checker

COMPLIANCE_DIR="$HOME/compliance"
REPORT_FILE="$COMPLIANCE_DIR/reports/system_config_$(date +%Y%m%d_%H%M%S).txt"

mkdir -p "$COMPLIANCE_DIR/reports"

echo "=== SYSTEM CONFIGURATION COMPLIANCE CHECK ===" > "$REPORT_FILE"
echo "Date: $(date)" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Check SSH configuration
echo "=== SSH Configuration ===" >> "$REPORT_FILE"
echo "PermitRootLogin setting:" >> "$REPORT_FILE"
grep "^PermitRootLogin" /etc/ssh/sshd_config >> "$REPORT_FILE" 2>/dev/null || echo "Default setting" >> "$REPORT_FILE"

echo "PasswordAuthentication setting:" >> "$REPORT_FILE"
grep "^PasswordAuthentication" /etc/ssh/sshd_config >> "$REPORT_FILE" 2>/dev/null || echo "Default setting" >> "$REPORT_FILE"

echo "" >> "$REPORT_FILE"

# Check firewall status
echo "=== Firewall Status ===" >> "$REPORT_FILE"
sudo ufw status >> "$REPORT_FILE" 2>/dev/null || echo "UFW not configured" >> "$REPORT_FILE"

echo "" >> "$REPORT_FILE"

# Check for unnecessary services
echo "=== Running Services ===" >> "$REPORT_FILE"
systemctl list-units --type=service --state=running | grep -E "(telnet|ftp|rsh)" >> "$REPORT_FILE" || echo "No insecure services detected" >> "$REPORT_FILE"

echo "" >> "$REPORT_FILE"

# Check system updates
echo "=== System Updates ===" >> "$REPORT_FILE"
echo "Available security updates:" >> "$REPORT_FILE"
apt list --upgradable 2>/dev/null | grep -i security | wc -l >> "$REPORT_FILE"

echo "System configuration compliance check completed: $REPORT_FILE"
EOF

# Make script executable
chmod +x scripts/check_system_config.sh
```

### Part C: Automated Compliance Monitoring

1. **Create a master compliance monitoring script:**
```bash
# Create master compliance monitoring script
cat > scripts/compliance_monitor.sh << 'EOF'
#!/bin/bash
# Master Compliance Monitoring Script

COMPLIANCE_DIR="$HOME/compliance"
DATE=$(date +%Y%m%d_%H%M%S)
MASTER_REPORT="$COMPLIANCE_DIR/reports/compliance_summary_$DATE.txt"

mkdir -p "$COMPLIANCE_DIR/reports"

echo "Starting comprehensive compliance monitoring..."

# Create master report header
echo "=== COMPREHENSIVE COMPLIANCE MONITORING REPORT ===" > "$MASTER_REPORT"
echo "Generated: $(date)" >> "$MASTER_REPORT"
echo "System: $(hostname)" >> "$MASTER_REPORT"
echo "User: $(whoami)" >> "$MASTER_REPORT"
echo "" >> "$MASTER_REPORT"

# Run password policy check
echo "Running password policy compliance check..."
bash "$COMPLIANCE_DIR/scripts/check_password_policy.sh"
echo "=== PASSWORD POLICY COMPLIANCE ===" >> "$MASTER_REPORT"
cat "$COMPLIANCE_DIR/reports/password_policy_"*.txt | tail -20 >> "$MASTER_REPORT"
echo "" >> "$MASTER_REPORT"

# Run file permissions check
echo "Running file permissions compliance check..."
bash "$COMPLIANCE_DIR/scripts/check_file_permissions.sh"
echo "=== FILE PERMISSIONS COMPLIANCE ===" >> "$MASTER_REPORT"
cat "$COMPLIANCE_DIR/reports/file_permissions_"*.txt | tail -20 >> "$MASTER_REPORT"
echo "" >> "$MASTER_REPORT"

# Run system configuration check
echo "Running system configuration compliance check..."
bash "$COMPLIANCE_DIR/scripts/check_system_config.sh"
echo "=== SYSTEM CONFIGURATION COMPLIANCE ===" >> "$MASTER_REPORT"
cat "$COMPLIANCE_DIR/reports/system_config_"*.txt | tail -20 >> "$MASTER_REPORT"
echo "" >> "$MASTER_REPORT"

# Check audit logs for compliance violations
echo "=== AUDIT LOG ANALYSIS ===" >> "$MASTER_REPORT"
echo "Recent audit events:" >> "$MASTER_REPORT"
sudo ausearch -ts today 2>/dev/null | tail -10 >> "$MASTER_REPORT" || echo "No recent audit events" >> "$MASTER_REPORT"

echo "Compliance monitoring completed: $MASTER_REPORT"
echo "Summary report available at: $MASTER_REPORT"
EOF

# Make script executable
chmod +x scripts/compliance_monitor.sh
```

2. **Test the compliance monitoring system:**
```bash
# Run individual compliance checks
./scripts/check_password_policy.sh
./scripts/check_file_permissions.sh
./scripts/check_system_config.sh

# Run comprehensive compliance monitoring
./scripts/compliance_monitor.sh

# View the compliance summary
cat reports/compliance_summary_*.txt | head -50
```

### ✅ Checkpoint 3
**Verify your work:**
- [ ] Audit system configured and running
- [ ] Audit rules applied for compliance monitoring
- [ ] Password policy compliance checker working
- [ ] File permissions compliance checker functional
- [ ] System configuration compliance checker operational
- [ ] Master compliance monitoring script generating reports

---

## Exercise 4: Integrated GRC Framework Implementation

**Time Allocation: 60 minutes**

In this final exercise, you'll integrate all the components you've built into a comprehensive GRC framework.

### Learning Objectives
- Integrate governance, risk, and compliance components
- Create a unified GRC management system
- Implement automated GRC workflows
- Generate comprehensive GRC reports

### Part A: GRC System Integration

1. **Create an integrated GRC directory structure:**
```bash
# Create comprehensive GRC system structure
mkdir -p ~/grc_system/{governance,risk,compliance}/{policies,data,reports,scripts}
mkdir -p ~/grc_system/integration/{config,scripts,reports}
cd ~/grc_system
```

2. **Create GRC system configuration:**
```bash
# Create master GRC configuration
cat > integration/config/grc_config.conf << 'EOF'
# Master GRC System Configuration

# Base directories
GRC_BASE="$HOME/grc_system"
GOVERNANCE_DIR="$GRC_BASE/governance"
RISK_DIR="$GRC_BASE/risk"
COMPLIANCE_DIR="$GRC_BASE/compliance"
INTEGRATION_DIR="$GRC_BASE/integration"

# Report settings
REPORT_FORMAT="markdown"
INCLUDE_CHARTS="no"
RETENTION_DAYS=90

# Notification settings
ENABLE_ALERTS="yes"
ALERT_EMAIL="admin@example.com"

# Thresholds
HIGH_RISK_THRESHOLD=8
MEDIUM_RISK_THRESHOLD=5
COMPLIANCE_FAILURE_THRESHOLD=3
EOF
```

3. **Create symbolic links to existing work:**
```bash
# Link existing governance work
ln -s ~/grc_workspace/* governance/ 2>/dev/null

# Link existing risk assessment work
ln -s ~/risk_assessment/* risk/ 2>/dev/null

# Link existing compliance work
ln -s ~/compliance/* compliance/ 2>/dev/null
```

### Part B: Unified GRC Workflow

1. **Create a master GRC execution script:**
```bash
# Create master GRC workflow script
cat > integration/scripts/grc_workflow.sh << 'EOF'
#!/bin/bash
# Master GRC Workflow Script

# Source configuration
source ~/grc_system/integration/config/grc_config.conf

# Create integration reports directory
mkdir -p "$INTEGRATION_DIR/reports"

DATE=$(date +%Y%m%d_%H%M%S)
MASTER_REPORT="$INTEGRATION_DIR/reports/grc_master_report_$DATE.md"

echo "Starting comprehensive GRC workflow execution..."

# Initialize master report
cat > "$MASTER_REPORT" << 'HEADER'
# Comprehensive GRC Framework Report

**Generated:** $(date)  
**System:** $(hostname)  
**Framework Version:** 1.0

## Executive Summary

This report provides a comprehensive overview of the organization's Governance, Risk, and Compliance posture based on automated assessments and monitoring.

HEADER

# Add current date to report
sed -i "s/\$(date)/$(date)/" "$MASTER_REPORT"
sed -i "s/\$(hostname)/$(hostname)/" "$MASTER_REPORT"

# Governance Assessment
echo "## Governance Assessment" >> "$MASTER_REPORT"
echo "" >> "$MASTER_REPORT"
echo "### Policy Documentation Status" >> "$MASTER_REPORT"
POLICY_COUNT=$(find "$GOVERNANCE_DIR" -name "*.md" -type f 2>/dev/null | wc -l)
echo "- Total policies documented: $POLICY_COUNT" >> "$MASTER_REPORT"
echo "- Last policy update: $(find "$GOVERNANCE_DIR" -name "*.md" -type f -exec stat -c %y {} \; 2>/dev/null | sort | tail -1 | cut -d' ' -f1)" >> "$MASTER_REPORT"
echo "" >> "$MASTER_REPORT"

# Risk Assessment
echo "## Risk Assessment" >> "$MASTER_REPORT"
echo "" >> "$MASTER_REPORT"

# Run risk assessment if scripts exist
if [ -f "$RISK_DIR/scripts/analyze_risks.sh" ]; then
    echo "Running risk assessment..."
    cd "$RISK_DIR" && bash scripts/analyze_risks.sh
    echo "### Latest Risk Analysis" >> "$MASTER_REPORT"
    LATEST_RISK_REPORT=$(ls -t "$RISK_DIR/reports/risk_analysis_"*.txt 2>/dev/null | head -1)
    if [ -n "$LATEST_RISK_REPORT" ]; then
        echo '```' >> "$MASTER_REPORT"
        tail -20 "$LATEST_RISK_REPORT" >> "$MASTER_REPORT"
        echo '```' >> "$MASTER_REPORT"
    fi
fi
echo "" >> "$MASTER_REPORT"

# Compliance Assessment
echo "## Compliance Assessment" >> "$MASTER_REPORT"
echo "" >> "$MASTER_REPORT"

# Run compliance monitoring if scripts exist
if [ -f "$COMPLIANCE_DIR/scripts/compliance_monitor.sh" ]; then
    echo "Running compliance monitoring..."
    cd "$COMPLIANCE_DIR" && bash scripts/compliance_monitor.sh
    echo "### Latest Compliance Status" >> "$MASTER_REPORT"
    LATEST_COMPLIANCE_REPORT=$(ls -t "$COMPLIANCE_DIR/reports/compliance_summary_"*.txt 2>/dev/null | head -1)
    if [ -n "$LATEST_COMPLIANCE_REPORT" ]; then
        echo '```' >> "$MASTER_REPORT"
        tail -20 "$LATEST_COMPLIANCE_REPORT" >> "$MASTER_REPORT"
        echo '```' >> "$MASTER_REPORT"
    fi
fi
echo "" >> "$MASTER_REPORT"

# GRC Integration Summary
echo "## GRC Integration Summary" >> "$MASTER_REPORT"
echo "" >> "$MASTER_REPORT"
echo "### Key Metrics" >> "$MASTER_REPORT"
echo "- Governance policies: $POLICY_COUNT" >> "$MASTER_REPORT"
echo "- Risk assessments completed: $(find "$RISK_DIR/reports" -name "risk_analysis_*.txt" 2>/dev/null | wc -l)" >> "$MASTER_REPORT"
echo "- Compliance checks performed: $(find "$COMPLIANCE_DIR/reports" -name "compliance_summary_*.txt" 2>/dev/null | wc -l)" >> "$MASTER_REPORT"
echo "- Report generation date: $(date)" >> "$MASTER_REPORT"
echo "" >> "$MASTER_REPORT"

echo "## Recommendations" >> "$MASTER_REPORT"
echo "" >> "$MASTER_REPORT"
echo "1. **Governance:** Ensure all policies are reviewed and updated regularly" >> "$MASTER_REPORT"
echo "2. **Risk Management:** Implement automated risk monitoring for critical systems" >> "$MASTER_REPORT"
echo "3. **Compliance:** Schedule regular compliance assessments and remediation" >> "$MASTER_REPORT"
echo "4. **Integration:** Continue to enhance automated GRC workflows" >> "$MASTER_REPORT"

echo "GRC workflow completed successfully!"
echo "Master report generated: $MASTER_REPORT"

# Return to original directory
cd ~/grc_system
EOF

# Make script executable
chmod +x integration/scripts/grc_workflow.sh
```

2. **Create a GRC dashboard script:**
```bash
# Create GRC dashboard script
cat > integration/scripts/grc_dashboard.sh << 'EOF'
#!/bin/bash
# GRC Framework Dashboard

# Source configuration
source ~/grc_system/integration/config/grc_config.conf

clear
echo "=========================================="
echo "    ICDFA GRC Framework Dashboard"
echo "=========================================="
echo "Last Updated: $(date)"
echo "System: $(hostname)"
echo ""

# Governance Status
echo "📋 GOVERNANCE STATUS:"
POLICY_COUNT=$(find "$GOVERNANCE_DIR" -name "*.md" -type f 2>/dev/null | wc -l)
echo "   ├─ Active Policies: $POLICY_COUNT"
RECENT_POLICIES=$(find "$GOVERNANCE_DIR" -name "*.md" -type f -mtime -7 2>/dev/null | wc -l)
echo "   ├─ Recent Updates (7 days): $RECENT_POLICIES"
echo "   └─ Status: $([ $POLICY_COUNT -gt 0 ] && echo "✅ Active" || echo "⚠️  Needs Setup")"
echo ""

# Risk Management Status
echo "⚠️  RISK MANAGEMENT STATUS:"
RISK_REPORTS=$(find "$RISK_DIR/reports" -name "risk_analysis_*.txt" 2>/dev/null | wc -l)
echo "   ├─ Risk Assessments: $RISK_REPORTS"
RECENT_RISKS=$(find "$RISK_DIR/reports" -name "risk_analysis_*.txt" -mtime -1 2>/dev/null | wc -l)
echo "   ├─ Recent Assessments (24h): $RECENT_RISKS"
echo "   └─ Status: $([ $RECENT_RISKS -gt 0 ] && echo "✅ Current" || echo "⚠️  Needs Update")"
echo ""

# Compliance Status
echo "✅ COMPLIANCE STATUS:"
COMPLIANCE_REPORTS=$(find "$COMPLIANCE_DIR/reports" -name "compliance_summary_*.txt" 2>/dev/null | wc -l)
echo "   ├─ Compliance Checks: $COMPLIANCE_REPORTS"
RECENT_COMPLIANCE=$(find "$COMPLIANCE_DIR/reports" -name "compliance_summary_*.txt" -mtime -1 2>/dev/null | wc -l)
echo "   ├─ Recent Checks (24h): $RECENT_COMPLIANCE"
echo "   └─ Status: $([ $RECENT_COMPLIANCE -gt 0 ] && echo "✅ Compliant" || echo "⚠️  Needs Check")"
echo ""

# System Health
echo "🖥️  SYSTEM HEALTH:"
LOAD_AVG=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | sed 's/,//')
echo "   ├─ Load Average: $LOAD_AVG"
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}')
echo "   ├─ Disk Usage: $DISK_USAGE"
MEMORY_USAGE=$(free | awk 'NR==2{printf "%.0f%%", $3*100/$2}')
echo "   └─ Memory Usage: $MEMORY_USAGE"
echo ""

echo "📊 QUICK ACTIONS:"
echo "   1. Run full GRC workflow: ./integration/scripts/grc_workflow.sh"
echo "   2. View latest reports: ls -la integration/reports/"
echo "   3. Update dashboard: ./integration/scripts/grc_dashboard.sh"
echo ""
echo "=========================================="
EOF

# Make script executable
chmod +x integration/scripts/grc_dashboard.sh
```

### Part C: Testing the Integrated System

1. **Run the complete GRC workflow:**
```bash
# Execute the master GRC workflow
./integration/scripts/grc_workflow.sh
```

2. **View the GRC dashboard:**
```bash
# Display the GRC dashboard
./integration/scripts/grc_dashboard.sh
```

3. **Review generated reports:**
```bash
# List all generated reports
find . -name "*.txt" -o -name "*.md" | grep -E "(report|summary)" | sort

# View the latest master report
LATEST_MASTER=$(ls -t integration/reports/grc_master_report_*.md | head -1)
if [ -n "$LATEST_MASTER" ]; then
    echo "Latest Master Report:"
    head -50 "$LATEST_MASTER"
fi
```

### ✅ Final Checkpoint
**Verify your complete GRC system:**
- [ ] Integrated GRC directory structure created
- [ ] Master GRC workflow script functional
- [ ] GRC dashboard displaying system status
- [ ] Master reports being generated
- [ ] All components working together
- [ ] System demonstrating GRC framework principles

---

## Lab Completion and Reflection

### Summary of Accomplishments

Congratulations! You have successfully completed the Week 1 Linux Lab on GRC Frameworks and Principles. You have:

1. **Built a Governance Documentation Framework** using Linux file systems and permissions
2. **Implemented Risk Assessment Data Collection** using command-line tools and scripts
3. **Created Compliance Monitoring Systems** using Linux auditing and security tools
4. **Integrated All Components** into a comprehensive GRC framework

### Key Skills Developed

- Linux command-line proficiency for GRC applications
- Understanding of file permissions and access controls in governance
- Automated data collection and analysis for risk assessment
- System auditing and compliance monitoring implementation
- Script development for GRC automation
- Integration of multiple GRC components into unified systems

### Reflection Questions

Please answer the following questions to reinforce your learning:

1. **How do Linux file permissions support governance principles?**
   
   _Your answer:_
   ________________________________________________
   ________________________________________________

2. **What are the advantages of using command-line tools for risk assessment?**
   
   _Your answer:_
   ________________________________________________
   ________________________________________________

3. **How can automated compliance monitoring improve organizational security?**
   
   _Your answer:_
   ________________________________________________
   ________________________________________________

4. **What challenges did you encounter during the lab, and how did you resolve them?**
   
   _Your answer:_
   ________________________________________________
   ________________________________________________

### Next Steps

To prepare for Week 2's lab on Regulatory Environment and Standards:

1. **Review** the regulatory frameworks covered in Week 2 reading materials
2. **Research** Linux tools for regulatory compliance monitoring
3. **Practice** the commands and scripts you learned in this lab
4. **Prepare** questions about specific regulatory requirements

### Additional Practice

If you want to extend your learning:

1. **Enhance Scripts**: Add error handling and logging to your scripts
2. **Automate Further**: Set up cron jobs to run assessments automatically
3. **Integrate Tools**: Explore integration with external GRC tools
4. **Security Hardening**: Implement additional security measures

---

## Troubleshooting Guide

### Common Issues and Solutions

#### Permission Denied Errors
```bash
# Check current user and groups
whoami
groups

# Fix ownership issues
sudo chown -R $USER:$USER ~/directory_name

# Fix permission issues
chmod +x script_name.sh
```

#### Script Execution Problems
```bash
# Check script syntax
bash -n script_name.sh

# Run with debugging
bash -x script_name.sh

# Check file permissions
ls -la script_name.sh
```

#### Missing Commands or Tools
```bash
# Update package lists
sudo apt update

# Install missing tools
sudo apt install package_name

# Check if command exists
which command_name
```

#### Audit System Issues
```bash
# Check auditd status
sudo systemctl status auditd

# Restart auditd
sudo systemctl restart auditd

# Check audit rules
sudo auditctl -l
```

### Getting Help

If you encounter issues during the lab:

1. **Check the error message** carefully and search for specific solutions
2. **Review the commands** you executed to identify potential mistakes
3. **Ask your instructor** for assistance with complex problems
4. **Collaborate with classmates** to share solutions and learn together
5. **Consult documentation** using `man command_name` for detailed information

---

**Lab Completed Successfully! 🎉**

*You have successfully implemented a comprehensive GRC framework using Linux tools and demonstrated practical understanding of governance, risk, and compliance principles through hands-on exercises.*

