# ICDFA GRC102: Information Security Governance
## Week 1 Linux Lab Assignment: Implementing Security Governance Controls

### Overview

This hands-on lab will guide you through implementing and testing security governance controls using Linux. You will configure security policies, implement access controls, set up security monitoring, and document governance processes—all using Linux command-line tools and security utilities.

### Learning Objectives

By completing this lab, you will be able to:
- Implement security governance controls using Linux tools
- Configure and enforce security policies through technical controls
- Set up monitoring and logging for security governance
- Document security governance processes and controls
- Test and validate the effectiveness of implemented controls

### Lab Environment

- Ubuntu Linux 20.04 LTS server
- User account with sudo privileges
- Internet access for package installation
- 3 hours estimated completion time

### Prerequisites

- Basic familiarity with Linux command line
- Understanding of information security governance principles
- Knowledge of basic security controls

### Part 1: Setting Up a Security Governance Framework (25 points)

In this section, you will establish the foundation for a security governance framework by creating the necessary directory structure, documentation, and initial configuration.

#### 1.1 Create Governance Directory Structure

1. Create a directory structure for your security governance documentation:

```bash
sudo mkdir -p /etc/security_governance/{policies,procedures,controls,logs,reports,audits}
sudo chmod 750 /etc/security_governance
sudo chown -R $(whoami):$(whoami) /etc/security_governance
```

2. Create a README file explaining the purpose of each directory:

```bash
cat > /etc/security_governance/README.md << 'EOF'
# Security Governance Framework

This directory structure contains the components of our security governance framework:

- policies: Security policies approved by management
- procedures: Step-by-step procedures for implementing policies
- controls: Technical controls and configurations
- logs: Security-related logs and monitoring data
- reports: Security status reports and metrics
- audits: Security audit results and findings

This framework follows ISO 27001 and COBIT principles for information security governance.
EOF
```

#### 1.2 Create a Security Policy Document

Create a basic information security policy document:

```bash
cat > /etc/security_governance/policies/information_security_policy.md << 'EOF'
# Information Security Policy

## 1. Purpose
This policy establishes guidelines for protecting the confidentiality, integrity, and availability of information assets.

## 2. Scope
This policy applies to all systems, users, networks, and data owned by or operated on behalf of the organization.

## 3. Policy Statements

### 3.1 Access Control
- Access to information systems must be limited to authorized users
- Authentication must use strong passwords or multi-factor authentication
- Access rights must be reviewed quarterly

### 3.2 System Security
- All systems must be hardened according to industry standards
- Security patches must be applied within 30 days of release
- Anti-malware protection must be installed on all applicable systems

### 3.3 Data Protection
- Sensitive data must be encrypted at rest and in transit
- Data must be classified according to sensitivity
- Data retention and disposal must comply with legal requirements

### 3.4 Incident Management
- Security incidents must be reported within 24 hours
- Incident response procedures must be documented and tested
- Root cause analysis must be performed for all significant incidents

## 4. Compliance
Violations of this policy may result in disciplinary action.

## 5. Review
This policy will be reviewed annually.

## 6. Approval
Approved by: [Security Governance Committee]
Date: [Current Date]
Version: 1.0
EOF
```

#### 1.3 Create a Security Governance Committee Charter

Create a charter document for the security governance committee:

```bash
cat > /etc/security_governance/policies/governance_committee_charter.md << 'EOF'
# Security Governance Committee Charter

## Purpose
The Security Governance Committee provides oversight and direction for the organization's information security program.

## Responsibilities
- Approve security policies and standards
- Review security risk assessments
- Prioritize security initiatives
- Monitor security compliance
- Review security incidents
- Approve security exceptions
- Report security status to executive management

## Membership
- Chief Information Security Officer (Chair)
- Chief Information Officer
- Chief Risk Officer
- Legal Counsel
- Business Unit Representatives
- IT Operations Director
- Compliance Officer

## Meeting Frequency
The committee meets monthly, with additional meetings as needed.

## Reporting
The committee reports quarterly to the executive management team.

## Authority
The committee has authority to:
- Approve security policies
- Allocate security resources
- Enforce security requirements
- Escalate significant security issues to executive management

## Charter Review
This charter will be reviewed annually.

## Approval
Approved by: [Executive Management]
Date: [Current Date]
Version: 1.0
EOF
```

#### 1.4 Create a Risk Assessment Template

Create a template for security risk assessments:

```bash
cat > /etc/security_governance/procedures/risk_assessment_template.md << 'EOF'
# Security Risk Assessment Template

## Risk Identification
- **Asset**: [Identify the asset at risk]
- **Threat**: [Describe the threat]
- **Vulnerability**: [Describe the vulnerability]
- **Existing Controls**: [List current controls]

## Risk Analysis
- **Likelihood (1-5)**: [Rate the likelihood]
- **Impact (1-5)**: [Rate the impact]
- **Risk Score**: [Likelihood × Impact]

## Risk Evaluation
- **Risk Level**: [Low/Medium/High/Critical based on score]
- **Risk Acceptance Criteria**: [Criteria for accepting this level of risk]
- **Risk Owner**: [Person responsible for the risk]

## Risk Treatment
- **Treatment Option**: [Accept/Mitigate/Transfer/Avoid]
- **Treatment Plan**: [Description of treatment actions]
- **Required Resources**: [Resources needed for treatment]
- **Timeline**: [Implementation timeline]
- **Residual Risk**: [Expected risk after treatment]

## Approval
- **Approved By**: [Approver name and role]
- **Date**: [Approval date]
- **Next Review**: [Date for next review]
EOF
```

#### 1.5 Create a Security Metrics Dashboard Script

Create a simple script to generate a security metrics dashboard:

```bash
cat > /etc/security_governance/reports/generate_dashboard.sh << 'EOF'
#!/bin/bash

# Security Metrics Dashboard Generator
# This script collects security metrics and generates a dashboard report

echo "Generating Security Governance Dashboard..."
echo "============================================"
echo "Date: $(date)"
echo

# System Patching Status
echo "SYSTEM PATCHING STATUS"
echo "----------------------"
echo "Available updates: $(apt list --upgradable 2>/dev/null | grep -c upgradable)"
echo "Security updates: $(apt list --upgradable 2>/dev/null | grep -c security)"
echo

# User Account Status
echo "USER ACCOUNT STATUS"
echo "------------------"
echo "Total user accounts: $(cat /etc/passwd | wc -l)"
echo "Users with login capability: $(cat /etc/passwd | grep -v nologin | grep -v false | wc -l)"
echo "Users with sudo access: $(grep -l sudo /etc/group | wc -l)"
echo "Inactive accounts (no login > 90 days): $(lastlog -b 90 | grep -c "Never logged in")"
echo

# File Permission Issues
echo "FILE PERMISSION ISSUES"
echo "---------------------"
echo "World-writable files in /etc: $(find /etc -type f -perm -o=w 2>/dev/null | wc -l)"
echo "Files without owners: $(find / -nouser 2>/dev/null | wc -l)"
echo "SUID files: $(find / -perm -4000 2>/dev/null | wc -l)"
echo

# Security Events
echo "SECURITY EVENTS (Last 7 Days)"
echo "----------------------------"
echo "Failed login attempts: $(grep "Failed password" /var/log/auth.log | wc -l)"
echo "Successful logins: $(grep "session opened" /var/log/auth.log | wc -l)"
echo "Root login attempts: $(grep "authentication failure.*root" /var/log/auth.log | wc -l)"
echo

echo "SECURITY COMPLIANCE STATUS"
echo "-------------------------"
echo "Password policy enabled: $([ -f /etc/pam.d/common-password ] && echo "Yes" || echo "No")"
echo "Firewall enabled: $(ufw status | grep -q "active" && echo "Yes" || echo "No")"
echo "Automatic updates: $([ -f /etc/apt/apt.conf.d/20auto-upgrades ] && echo "Configured" || echo "Not configured")"
echo

echo "Report generated successfully."
EOF

chmod +x /etc/security_governance/reports/generate_dashboard.sh
```

### Part 2: Implementing Access Control Governance (25 points)

In this section, you will implement access control mechanisms that align with governance principles.

#### 2.1 Create User Groups for Role-Based Access Control

1. Create security groups for different roles:

```bash
sudo groupadd security_admins
sudo groupadd security_auditors
sudo groupadd security_operators
sudo groupadd data_custodians
```

2. Create test users and assign them to appropriate groups:

```bash
# Create users
sudo useradd -m -s /bin/bash admin_user
sudo useradd -m -s /bin/bash audit_user
sudo useradd -m -s /bin/bash operator_user
sudo useradd -m -s /bin/bash data_user

# Set passwords (in production, use more secure methods)
echo "admin_user:Password123!" | sudo chpasswd
echo "audit_user:Password123!" | sudo chpasswd
echo "operator_user:Password123!" | sudo chpasswd
echo "data_user:Password123!" | sudo chpasswd

# Assign users to groups
sudo usermod -aG security_admins admin_user
sudo usermod -aG security_auditors audit_user
sudo usermod -aG security_operators operator_user
sudo usermod -aG data_custodians data_user
```

#### 2.2 Configure Directory Permissions Based on Roles

Set up directory permissions that enforce separation of duties:

```bash
# Create directories for different roles
sudo mkdir -p /var/security/{admin,audit,operations,data}

# Set ownership and permissions
sudo chown root:security_admins /var/security/admin
sudo chown root:security_auditors /var/security/audit
sudo chown root:security_operators /var/security/operations
sudo chown root:data_custodians /var/security/data

# Set permissions (rwx for owner, rwx for group, no access for others)
sudo chmod 770 /var/security/admin
sudo chmod 770 /var/security/audit
sudo chmod 770 /var/security/operations
sudo chmod 770 /var/security/data

# Create test files in each directory
echo "Admin test file" | sudo tee /var/security/admin/test.txt
echo "Audit test file" | sudo tee /var/security/audit/test.txt
echo "Operations test file" | sudo tee /var/security/operations/test.txt
echo "Data test file" | sudo tee /var/security/data/test.txt
```

#### 2.3 Implement sudo Access Based on Governance Roles

Configure sudo access according to the principle of least privilege:

```bash
# Create sudo configuration files for each role
cat << 'EOF' | sudo tee /etc/sudoers.d/security_admins
%security_admins ALL=(ALL) ALL
EOF

cat << 'EOF' | sudo tee /etc/sudoers.d/security_auditors
%security_auditors ALL=(ALL) /usr/bin/find, /usr/bin/grep, /usr/bin/less, /usr/bin/cat, /usr/bin/tail
EOF

cat << 'EOF' | sudo tee /etc/sudoers.d/security_operators
%security_operators ALL=(ALL) /usr/bin/systemctl status *, /usr/bin/systemctl restart *, /usr/bin/systemctl start *, /usr/bin/systemctl stop *
EOF

# Set proper permissions on sudoers files
sudo chmod 440 /etc/sudoers.d/security_admins
sudo chmod 440 /etc/sudoers.d/security_auditors
sudo chmod 440 /etc/sudoers.d/security_operators
```

#### 2.4 Document Access Control Policy

Create a document that explains the access control implementation:

```bash
cat > /etc/security_governance/policies/access_control_policy.md << 'EOF'
# Access Control Policy

## 1. Purpose
This policy establishes the requirements for controlling access to information systems and data.

## 2. Scope
This policy applies to all users, systems, and data within the organization.

## 3. Role Definitions

### 3.1 Security Administrators
- Responsible for security configuration and management
- Full administrative access to security systems
- Authorized to modify security policies and controls

### 3.2 Security Auditors
- Responsible for reviewing security controls and compliance
- Read-only access to security configurations and logs
- Authorized to conduct security assessments

### 3.3 Security Operators
- Responsible for day-to-day security operations
- Limited administrative access to operational functions
- Authorized to respond to security events

### 3.4 Data Custodians
- Responsible for managing and protecting data
- Access limited to assigned data resources
- Authorized to implement data protection controls

## 4. Access Control Implementation

### 4.1 Authentication Requirements
- All users must authenticate using unique credentials
- Passwords must meet complexity requirements
- Multi-factor authentication required for privileged access

### 4.2 Authorization Controls
- Access granted based on role assignments
- Principle of least privilege enforced
- Separation of duties implemented for sensitive functions

### 4.3 Access Review
- User access rights reviewed quarterly
- Privileged access reviewed monthly
- Access promptly revoked upon role change or termination

## 5. Compliance
Violations of this policy may result in disciplinary action.

## 6. Review
This policy will be reviewed annually.

## 7. Approval
Approved by: [Security Governance Committee]
Date: [Current Date]
Version: 1.0
EOF
```

#### 2.5 Create an Access Review Script

Create a script to review user access:

```bash
cat > /etc/security_governance/procedures/access_review.sh << 'EOF'
#!/bin/bash

# Access Review Script
# This script generates a report of user access for governance review

echo "User Access Review Report"
echo "========================="
echo "Generated: $(date)"
echo

echo "1. Users with Administrative Access"
echo "----------------------------------"
echo "Users in sudo group:"
grep -Po '^sudo.+:\K.*$' /etc/group | tr ',' '\n'
echo
echo "Users with sudo configuration:"
for file in /etc/sudoers.d/*; do
  echo "File: $file"
  grep -v "^#" $file | grep -v "^$"
  echo
done

echo "2. User Group Memberships"
echo "------------------------"
for group in security_admins security_auditors security_operators data_custodians; do
  echo "Members of $group:"
  grep -Po "^$group.+:\K.*$" /etc/group | tr ',' '\n' | sed 's/^/- /'
  echo
done

echo "3. Last Login Information"
echo "------------------------"
lastlog | head -20

echo "4. Inactive Accounts (No login > 30 days)"
echo "----------------------------------------"
lastlog -b 30 | grep "Never logged in" | awk '{print $1}'

echo "5. Recently Created Accounts (Last 30 days)"
echo "------------------------------------------"
for user in $(cut -d: -f1 /etc/passwd); do
  create_date=$(sudo passwd -S "$user" | awk '{print $3}')
  days_since_created=$(( ($(date +%s) - $(date -d "$create_date" +%s)) / 86400 ))
  if [ "$days_since_created" -le 30 ]; then
    echo "$user (created $days_since_created days ago)"
  fi
done

echo
echo "End of Access Review Report"
EOF

chmod +x /etc/security_governance/procedures/access_review.sh
```

### Part 3: Setting Up Security Monitoring and Logging (25 points)

In this section, you will implement security monitoring and logging controls to support governance oversight.

#### 3.1 Configure System Logging

1. Install and configure rsyslog for centralized logging:

```bash
sudo apt update
sudo apt install -y rsyslog

# Create a directory for security logs
sudo mkdir -p /var/log/security
sudo chmod 750 /var/log/security

# Configure rsyslog to separate security-related logs
cat << 'EOF' | sudo tee /etc/rsyslog.d/30-security.conf
# Log authentication messages to security log
auth,authpriv.*                 /var/log/security/auth.log

# Log sudo commands
local6.*                        /var/log/security/sudo.log

# Log firewall messages
kern.warning                    /var/log/security/firewall.log

# Log all critical and higher priority messages
*.crit                          /var/log/security/critical.log
EOF

# Restart rsyslog to apply changes
sudo systemctl restart rsyslog
```

2. Configure sudo logging:

```bash
cat << 'EOF' | sudo tee /etc/sudoers.d/logging
Defaults log_output
Defaults!/usr/bin/sudoreplay !log_output
Defaults!/usr/local/bin/sudoreplay !log_output
Defaults!REBOOT !log_output
EOF

sudo chmod 440 /etc/sudoers.d/logging
```

#### 3.2 Set Up Auditd for Security Auditing

1. Install and configure auditd:

```bash
sudo apt install -y auditd

# Configure audit rules
cat << 'EOF' | sudo tee /etc/audit/rules.d/security-governance.rules
# Monitor changes to security governance files
-w /etc/security_governance/ -p wa -k security_governance

# Monitor authentication events
-w /etc/passwd -p wa -k identity
-w /etc/group -p wa -k identity
-w /etc/shadow -p wa -k identity
-w /etc/sudoers -p wa -k identity
-w /etc/sudoers.d/ -p wa -k identity

# Monitor system calls related to access control
-a always,exit -F arch=b64 -S chmod,fchmod,fchmodat -F auid>=1000 -F auid!=-1 -k perm_mod
-a always,exit -F arch=b32 -S chmod,fchmod,fchmodat -F auid>=1000 -F auid!=-1 -k perm_mod
-a always,exit -F arch=b64 -S chown,fchown,lchown,fchownat -F auid>=1000 -F auid!=-1 -k perm_mod
-a always,exit -F arch=b32 -S chown,fchown,lchown,fchownat -F auid>=1000 -F auid!=-1 -k perm_mod

# Monitor privileged command execution
-a always,exit -F path=/usr/bin/sudo -F perm=x -F auid>=1000 -F auid!=-1 -k privileged
-a always,exit -F path=/usr/bin/su -F perm=x -F auid>=1000 -F auid!=-1 -k privileged

# Monitor unsuccessful access attempts
-a always,exit -F arch=b64 -S open,openat,creat -F exit=-EACCES -F auid>=1000 -F auid!=-1 -k access
-a always,exit -F arch=b32 -S open,openat,creat -F exit=-EACCES -F auid>=1000 -F auid!=-1 -k access
-a always,exit -F arch=b64 -S open,openat,creat -F exit=-EPERM -F auid>=1000 -F auid!=-1 -k access
-a always,exit -F arch=b32 -S open,openat,creat -F exit=-EPERM -F auid>=1000 -F auid!=-1 -k access
EOF

# Restart auditd to apply changes
sudo systemctl restart auditd
```

2. Create an audit report script:

```bash
cat > /etc/security_governance/procedures/audit_report.sh << 'EOF'
#!/bin/bash

# Security Audit Report Generator
# This script generates reports from audit logs for governance review

REPORT_DIR="/etc/security_governance/reports"
mkdir -p "$REPORT_DIR"

REPORT_FILE="$REPORT_DIR/audit_report_$(date +%Y%m%d).txt"

echo "Security Audit Report" > "$REPORT_FILE"
echo "====================" >> "$REPORT_FILE"
echo "Generated: $(date)" >> "$REPORT_FILE"
echo >> "$REPORT_FILE"

echo "1. Authentication Events" >> "$REPORT_FILE"
echo "----------------------" >> "$REPORT_FILE"
echo "Failed authentication attempts:" >> "$REPORT_FILE"
ausearch -m USER_AUTH -sv no -i | grep -v "type=CRYPTO_KEY_USER" | tail -20 >> "$REPORT_FILE" 2>/dev/null
echo >> "$REPORT_FILE"

echo "2. Privilege Escalation" >> "$REPORT_FILE"
echo "---------------------" >> "$REPORT_FILE"
echo "Sudo command executions:" >> "$REPORT_FILE"
ausearch -k privileged -i | tail -20 >> "$REPORT_FILE" 2>/dev/null
echo >> "$REPORT_FILE"

echo "3. File Permission Changes" >> "$REPORT_FILE"
echo "------------------------" >> "$REPORT_FILE"
ausearch -k perm_mod -i | tail -20 >> "$REPORT_FILE" 2>/dev/null
echo >> "$REPORT_FILE"

echo "4. Access Denied Events" >> "$REPORT_FILE"
echo "---------------------" >> "$REPORT_FILE"
ausearch -k access -i | tail -20 >> "$REPORT_FILE" 2>/dev/null
echo >> "$REPORT_FILE"

echo "5. Security Governance Changes" >> "$REPORT_FILE"
echo "----------------------------" >> "$REPORT_FILE"
ausearch -k security_governance -i | tail -20 >> "$REPORT_FILE" 2>/dev/null
echo >> "$REPORT_FILE"

echo "6. Identity Changes" >> "$REPORT_FILE"
echo "-----------------" >> "$REPORT_FILE"
ausearch -k identity -i | tail -20 >> "$REPORT_FILE" 2>/dev/null
echo >> "$REPORT_FILE"

echo "Report saved to $REPORT_FILE"
EOF

chmod +x /etc/security_governance/procedures/audit_report.sh
```

#### 3.3 Implement Log Rotation for Security Logs

Configure log rotation to ensure logs are properly managed:

```bash
cat << 'EOF' | sudo tee /etc/logrotate.d/security
/var/log/security/*.log {
    weekly
    rotate 13
    compress
    delaycompress
    missingok
    notifempty
    create 0640 syslog adm
    sharedscripts
    postrotate
        /usr/lib/rsyslog/rsyslog-rotate
    endscript
}
EOF
```

#### 3.4 Create a Security Monitoring Policy

Document the security monitoring approach:

```bash
cat > /etc/security_governance/policies/security_monitoring_policy.md << 'EOF'
# Security Monitoring Policy

## 1. Purpose
This policy establishes requirements for monitoring information systems to detect security events and ensure compliance with security policies.

## 2. Scope
This policy applies to all information systems and networks within the organization.

## 3. Monitoring Requirements

### 3.1 Event Types to Monitor
The following event types must be monitored:
- Authentication attempts (successful and failed)
- Privileged operations
- Security policy changes
- Access control changes
- System configuration changes
- Security control failures
- Malware detection events
- Network security events

### 3.2 Log Management
- Logs must be stored in a secure, centralized location
- Logs must be protected from unauthorized access and modification
- Logs must be retained for a minimum of 13 months
- Log rotation must be implemented to manage storage
- Time synchronization must be implemented across all systems

### 3.3 Monitoring Responsibilities
- Security operations team is responsible for real-time monitoring
- Security governance team is responsible for compliance monitoring
- System administrators are responsible for system-specific monitoring
- All personnel are responsible for reporting suspicious activities

### 3.4 Review Requirements
- Critical security alerts must be reviewed within 1 hour
- Daily security summary reports must be reviewed each business day
- Weekly security trend reports must be reviewed by the security team
- Monthly compliance reports must be reviewed by the governance committee

## 4. Privacy Considerations
- Monitoring must comply with applicable privacy laws and regulations
- Personnel must be informed of monitoring activities
- Monitoring must be limited to business purposes
- Access to monitoring data must be restricted to authorized personnel

## 5. Incident Response Integration
- Security monitoring must be integrated with incident response procedures
- Monitoring systems must generate alerts for potential security incidents
- Monitoring data must be available for incident investigation

## 6. Compliance
Violations of this policy may result in disciplinary action.

## 7. Review
This policy will be reviewed annually.

## 8. Approval
Approved by: [Security Governance Committee]
Date: [Current Date]
Version: 1.0
EOF
```

#### 3.5 Create a Simple Intrusion Detection Script

Create a basic script to detect potential security issues:

```bash
cat > /etc/security_governance/controls/intrusion_detection.sh << 'EOF'
#!/bin/bash

# Simple Intrusion Detection Script
# This script checks for common security issues and reports findings

REPORT_DIR="/etc/security_governance/reports"
mkdir -p "$REPORT_DIR"

REPORT_FILE="$REPORT_DIR/security_check_$(date +%Y%m%d).txt"

echo "Security Check Report" > "$REPORT_FILE"
echo "====================" >> "$REPORT_FILE"
echo "Generated: $(date)" >> "$REPORT_FILE"
echo >> "$REPORT_FILE"

# Check for failed login attempts
echo "Failed Login Attempts (Last 24 Hours)" >> "$REPORT_FILE"
echo "------------------------------------" >> "$REPORT_FILE"
grep "Failed password" /var/log/auth.log | tail -20 >> "$REPORT_FILE"
echo >> "$REPORT_FILE"

# Check for unauthorized sudo usage
echo "Sudo Usage (Last 24 Hours)" >> "$REPORT_FILE"
echo "-------------------------" >> "$REPORT_FILE"
grep "sudo:" /var/log/auth.log | grep "COMMAND" | tail -20 >> "$REPORT_FILE"
echo >> "$REPORT_FILE"

# Check for modified system files
echo "Modified System Files (Last 24 Hours)" >> "$REPORT_FILE"
echo "-----------------------------------" >> "$REPORT_FILE"
find /etc -type f -mtime -1 | grep -v "/etc/security_governance" >> "$REPORT_FILE"
echo >> "$REPORT_FILE"

# Check for unusual listening ports
echo "Listening Network Ports" >> "$REPORT_FILE"
echo "---------------------" >> "$REPORT_FILE"
netstat -tuln | grep LISTEN >> "$REPORT_FILE"
echo >> "$REPORT_FILE"

# Check for suspicious processes
echo "Potentially Suspicious Processes" >> "$REPORT_FILE"
echo "------------------------------" >> "$REPORT_FILE"
ps aux | grep -v "root\|$(whoami)\|daemon\|bin\|sys\|sync\|games\|man\|lp\|mail\|news\|uucp\|proxy\|www-data\|backup\|list\|irc\|gnats\|nobody\|systemd\|syslog\|messagebus\|_apt\|sshd:" | tail -20 >> "$REPORT_FILE"
echo >> "$REPORT_FILE"

# Check for users with empty passwords
echo "Users With Empty Passwords" >> "$REPORT_FILE"
echo "------------------------" >> "$REPORT_FILE"
sudo cat /etc/shadow | awk -F: '($2==""){print $1}' >> "$REPORT_FILE"
echo >> "$REPORT_FILE"

# Check for unauthorized SUID files
echo "Potentially Unauthorized SUID Files" >> "$REPORT_FILE"
echo "--------------------------------" >> "$REPORT_FILE"
find / -type f -perm -4000 2>/dev/null | grep -v "/bin/\|/sbin/\|/usr/bin/\|/usr/sbin/\|/usr/lib/\|/usr/libexec/" >> "$REPORT_FILE"
echo >> "$REPORT_FILE"

echo "Report saved to $REPORT_FILE"
EOF

chmod +x /etc/security_governance/controls/intrusion_detection.sh
```

### Part 4: Implementing Security Policy Enforcement (25 points)

In this section, you will implement technical controls to enforce security policies.

#### 4.1 Configure Password Policy

Implement a password policy that aligns with governance requirements:

```bash
sudo apt install -y libpam-pwquality

# Configure password quality requirements
sudo cp /etc/pam.d/common-password /etc/pam.d/common-password.bak

# Update the password policy
sudo sed -i 's/pam_pwquality.so.*/pam_pwquality.so retry=3 minlen=12 difok=3 ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1 reject_username enforce_for_root/' /etc/pam.d/common-password

# Configure password aging
sudo cp /etc/login.defs /etc/login.defs.bak
sudo sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS   90/' /etc/login.defs
sudo sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS   1/' /etc/login.defs
sudo sed -i 's/^PASS_WARN_AGE.*/PASS_WARN_AGE   14/' /etc/login.defs

# Document the password policy
cat > /etc/security_governance/policies/password_policy.md << 'EOF'
# Password Policy

## 1. Purpose
This policy establishes requirements for creating and managing passwords to ensure system and data security.

## 2. Scope
This policy applies to all users and systems within the organization.

## 3. Password Requirements

### 3.1 Complexity Requirements
- Minimum length: 12 characters
- Must contain at least one uppercase letter
- Must contain at least one lowercase letter
- Must contain at least one digit
- Must contain at least one special character
- Must not contain the username
- Must differ from previous passwords by at least 3 characters

### 3.2 Password Aging
- Maximum password age: 90 days
- Minimum password age: 1 day
- Password expiration warning: 14 days

### 3.3 Account Lockout
- Accounts will be locked after 5 consecutive failed login attempts
- Locked accounts will automatically unlock after 30 minutes
- Administrators can manually unlock accounts if necessary

## 4. Password Management
- Passwords must not be shared with anyone
- Passwords must not be written down or stored in unsecured locations
- Password managers may be used to store passwords securely
- Default passwords must be changed immediately

## 5. Compliance
Violations of this policy may result in disciplinary action.

## 6. Review
This policy will be reviewed annually.

## 7. Approval
Approved by: [Security Governance Committee]
Date: [Current Date]
Version: 1.0
EOF
```

#### 4.2 Configure Account Lockout Policy

Implement account lockout to prevent brute force attacks:

```bash
sudo apt install -y libpam-faillock

# Configure faillock
cat << 'EOF' | sudo tee /etc/pam.d/common-auth
# Standard Un*x authentication.
auth    required                        pam_unix.so nullok
auth    required                        pam_faillock.so preauth silent audit deny=5 unlock_time=1800
auth    [success=1 default=bad]         pam_unix.so nullok
auth    [default=die]                   pam_faillock.so authfail audit deny=5 unlock_time=1800
auth    sufficient                      pam_faillock.so authsucc audit deny=5 unlock_time=1800
auth    requisite                       pam_deny.so
auth    required                        pam_permit.so
EOF

# Create a script to check locked accounts
cat > /etc/security_governance/procedures/check_locked_accounts.sh << 'EOF'
#!/bin/bash

# Check for locked accounts
echo "Checking for locked accounts..."
echo

for user in $(cut -d: -f1 /etc/passwd); do
  if [ -f /var/run/faillock/$user ]; then
    echo "User $user faillock status:"
    faillock --user $user
    echo
  fi
done

echo "To unlock an account, use: sudo faillock --user username --reset"
EOF

chmod +x /etc/security_governance/procedures/check_locked_accounts.sh
```

#### 4.3 Configure System Auditing Policy

Create a script to check system compliance with security policies:

```bash
cat > /etc/security_governance/procedures/compliance_check.sh << 'EOF'
#!/bin/bash

# Security Compliance Check Script
# This script checks system compliance with security policies

REPORT_DIR="/etc/security_governance/reports"
mkdir -p "$REPORT_DIR"

REPORT_FILE="$REPORT_DIR/compliance_check_$(date +%Y%m%d).txt"

echo "Security Compliance Check Report" > "$REPORT_FILE"
echo "===============================" >> "$REPORT_FILE"
echo "Generated: $(date)" >> "$REPORT_FILE"
echo >> "$REPORT_FILE"

# Check password policy compliance
echo "Password Policy Compliance" >> "$REPORT_FILE"
echo "------------------------" >> "$REPORT_FILE"
echo "Password quality module installed: $(dpkg -l | grep libpam-pwquality > /dev/null && echo "Yes" || echo "No")" >> "$REPORT_FILE"
echo "Password complexity configured: $(grep "pam_pwquality.so" /etc/pam.d/common-password > /dev/null && echo "Yes" || echo "No")" >> "$REPORT_FILE"
echo "Password aging configured:" >> "$REPORT_FILE"
grep "PASS_MAX_DAYS\|PASS_MIN_DAYS\|PASS_WARN_AGE" /etc/login.defs >> "$REPORT_FILE"
echo >> "$REPORT_FILE"

# Check account lockout policy compliance
echo "Account Lockout Policy Compliance" >> "$REPORT_FILE"
echo "-------------------------------" >> "$REPORT_FILE"
echo "Faillock module installed: $(dpkg -l | grep libpam-faillock > /dev/null && echo "Yes" || echo "No")" >> "$REPORT_FILE"
echo "Faillock configured: $(grep "pam_faillock.so" /etc/pam.d/common-auth > /dev/null && echo "Yes" || echo "No")" >> "$REPORT_FILE"
echo >> "$REPORT_FILE"

# Check audit policy compliance
echo "Audit Policy Compliance" >> "$REPORT_FILE"
echo "-----------------------" >> "$REPORT_FILE"
echo "Auditd installed: $(dpkg -l | grep auditd > /dev/null && echo "Yes" || echo "No")" >> "$REPORT_FILE"
echo "Auditd running: $(systemctl is-active auditd)" >> "$REPORT_FILE"
echo "Audit rules configured: $(test -f /etc/audit/rules.d/security-governance.rules && echo "Yes" || echo "No")" >> "$REPORT_FILE"
echo >> "$REPORT_FILE"

# Check logging policy compliance
echo "Logging Policy Compliance" >> "$REPORT_FILE"
echo "------------------------" >> "$REPORT_FILE"
echo "Rsyslog installed: $(dpkg -l | grep rsyslog > /dev/null && echo "Yes" || echo "No")" >> "$REPORT_FILE"
echo "Rsyslog running: $(systemctl is-active rsyslog)" >> "$REPORT_FILE"
echo "Security logging configured: $(test -f /etc/rsyslog.d/30-security.conf && echo "Yes" || echo "No")" >> "$REPORT_FILE"
echo "Log rotation configured: $(test -f /etc/logrotate.d/security && echo "Yes" || echo "No")" >> "$REPORT_FILE"
echo >> "$REPORT_FILE"

# Check firewall policy compliance
echo "Firewall Policy Compliance" >> "$REPORT_FILE"
echo "--------------------------" >> "$REPORT_FILE"
echo "UFW installed: $(dpkg -l | grep ufw > /dev/null && echo "Yes" || echo "No")" >> "$REPORT_FILE"
echo "Firewall status: $(ufw status | grep Status | cut -d: -f2 | xargs)" >> "$REPORT_FILE"
echo >> "$REPORT_FILE"

# Check file permissions compliance
echo "File Permissions Compliance" >> "$REPORT_FILE"
echo "---------------------------" >> "$REPORT_FILE"
echo "World-writable files in /etc: $(find /etc -type f -perm -o=w 2>/dev/null | wc -l)" >> "$REPORT_FILE"
echo "Unauthorized SUID files: $(find / -type f -perm -4000 2>/dev/null | grep -v "/bin/\|/sbin/\|/usr/bin/\|/usr/sbin/\|/usr/lib/\|/usr/libexec/" | wc -l)" >> "$REPORT_FILE"
echo >> "$REPORT_FILE"

# Check security governance documentation compliance
echo "Security Governance Documentation Compliance" >> "$REPORT_FILE"
echo "------------------------------------------" >> "$REPORT_FILE"
echo "Information security policy: $(test -f /etc/security_governance/policies/information_security_policy.md && echo "Yes" || echo "No")" >> "$REPORT_FILE"
echo "Access control policy: $(test -f /etc/security_governance/policies/access_control_policy.md && echo "Yes" || echo "No")" >> "$REPORT_FILE"
echo "Password policy: $(test -f /etc/security_governance/policies/password_policy.md && echo "Yes" || echo "No")" >> "$REPORT_FILE"
echo "Security monitoring policy: $(test -f /etc/security_governance/policies/security_monitoring_policy.md && echo "Yes" || echo "No")" >> "$REPORT_FILE"
echo "Governance committee charter: $(test -f /etc/security_governance/policies/governance_committee_charter.md && echo "Yes" || echo "No")" >> "$REPORT_FILE"
echo >> "$REPORT_FILE"

echo "Report saved to $REPORT_FILE"
EOF

chmod +x /etc/security_governance/procedures/compliance_check.sh
```

#### 4.4 Configure Basic Firewall Rules

Set up a basic firewall configuration:

```bash
# Ensure UFW is installed
sudo apt install -y ufw

# Configure basic firewall rules
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Enable the firewall
sudo ufw --force enable

# Document the firewall policy
cat > /etc/security_governance/policies/firewall_policy.md << 'EOF'
# Firewall Policy

## 1. Purpose
This policy establishes requirements for network firewall protection to secure the organization's systems and data.

## 2. Scope
This policy applies to all network devices, systems, and connections within the organization.

## 3. Firewall Requirements

### 3.1 Default Stance
- All inbound traffic must be denied by default
- All outbound traffic may be allowed by default, subject to restrictions
- All firewall rules must follow the principle of least privilege

### 3.2 Required Rules
- SSH (TCP port 22) access must be limited to authorized sources
- HTTP (TCP port 80) and HTTPS (TCP port 443) may be allowed for web services
- All other services must be explicitly justified and documented

### 3.3 Prohibited Traffic
- Any traffic that cannot be positively identified must be blocked
- Known malicious sources must be blocked
- Unnecessary or high-risk protocols must be blocked

### 3.4 Management and Monitoring
- Firewall configurations must be backed up before changes
- Firewall rule changes must follow change management procedures
- Firewall logs must be monitored for security events
- Firewall effectiveness must be tested periodically

## 4. Firewall Administration
- Firewall administration must be limited to authorized personnel
- Firewall changes must be documented and approved
- Firewall configurations must be reviewed quarterly

## 5. Compliance
Violations of this policy may result in disciplinary action.

## 6. Review
This policy will be reviewed annually.

## 7. Approval
Approved by: [Security Governance Committee]
Date: [Current Date]
Version: 1.0
EOF
```

#### 4.5 Create a Security Governance Dashboard

Create a simple web-based dashboard for security governance:

```bash
# Install required packages
sudo apt install -y apache2

# Create dashboard directory
sudo mkdir -p /var/www/html/security-governance
sudo chown -R $(whoami):$(whoami) /var/www/html/security-governance

# Create dashboard HTML
cat > /var/www/html/security-governance/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Security Governance Dashboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        header {
            background-color: #2c3e50;
            color: white;
            padding: 20px;
            text-align: center;
            margin-bottom: 20px;
        }
        .card {
            background-color: white;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            padding: 20px;
            margin-bottom: 20px;
        }
        .status-indicator {
            display: inline-block;
            width: 15px;
            height: 15px;
            border-radius: 50%;
            margin-right: 10px;
        }
        .status-good {
            background-color: #2ecc71;
        }
        .status-warning {
            background-color: #f39c12;
        }
        .status-critical {
            background-color: #e74c3c;
        }
        .status-unknown {
            background-color: #95a5a6;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #f2f2f2;
        }
        .metric-container {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
        }
        .metric-box {
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 5px;
            padding: 15px;
            margin-bottom: 15px;
            width: calc(25% - 20px);
            box-sizing: border-box;
        }
        .metric-value {
            font-size: 24px;
            font-weight: bold;
            margin: 10px 0;
        }
        .metric-label {
            font-size: 14px;
            color: #6c757d;
        }
        @media (max-width: 768px) {
            .metric-box {
                width: calc(50% - 15px);
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <h1>Security Governance Dashboard</h1>
            <p>Last updated: <span id="last-updated">Loading...</span></p>
        </header>
        
        <div class="card">
            <h2>Security Compliance Status</h2>
            <div class="metric-container">
                <div class="metric-box">
                    <div class="metric-label">Policy Compliance</div>
                    <div class="metric-value">85%</div>
                </div>
                <div class="metric-box">
                    <div class="metric-label">Control Effectiveness</div>
                    <div class="metric-value">78%</div>
                </div>
                <div class="metric-box">
                    <div class="metric-label">Risk Coverage</div>
                    <div class="metric-value">92%</div>
                </div>
                <div class="metric-box">
                    <div class="metric-label">Governance Maturity</div>
                    <div class="metric-value">3.2/5</div>
                </div>
            </div>
        </div>
        
        <div class="card">
            <h2>Security Policy Status</h2>
            <table>
                <thead>
                    <tr>
                        <th>Policy</th>
                        <th>Status</th>
                        <th>Last Review</th>
                        <th>Next Review</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Information Security Policy</td>
                        <td><span class="status-indicator status-good"></span> Implemented</td>
                        <td>Today</td>
                        <td>1 year from today</td>
                    </tr>
                    <tr>
                        <td>Access Control Policy</td>
                        <td><span class="status-indicator status-good"></span> Implemented</td>
                        <td>Today</td>
                        <td>1 year from today</td>
                    </tr>
                    <tr>
                        <td>Password Policy</td>
                        <td><span class="status-indicator status-good"></span> Implemented</td>
                        <td>Today</td>
                        <td>1 year from today</td>
                    </tr>
                    <tr>
                        <td>Security Monitoring Policy</td>
                        <td><span class="status-indicator status-good"></span> Implemented</td>
                        <td>Today</td>
                        <td>1 year from today</td>
                    </tr>
                    <tr>
                        <td>Firewall Policy</td>
                        <td><span class="status-indicator status-good"></span> Implemented</td>
                        <td>Today</td>
                        <td>1 year from today</td>
                    </tr>
                </tbody>
            </table>
        </div>
        
        <div class="card">
            <h2>Security Control Status</h2>
            <table>
                <thead>
                    <tr>
                        <th>Control</th>
                        <th>Status</th>
                        <th>Last Check</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Password Complexity</td>
                        <td><span class="status-indicator status-good"></span> Enforced</td>
                        <td>Today</td>
                    </tr>
                    <tr>
                        <td>Account Lockout</td>
                        <td><span class="status-indicator status-good"></span> Enforced</td>
                        <td>Today</td>
                    </tr>
                    <tr>
                        <td>System Logging</td>
                        <td><span class="status-indicator status-good"></span> Enabled</td>
                        <td>Today</td>
                    </tr>
                    <tr>
                        <td>Security Auditing</td>
                        <td><span class="status-indicator status-good"></span> Enabled</td>
                        <td>Today</td>
                    </tr>
                    <tr>
                        <td>Firewall Protection</td>
                        <td><span class="status-indicator status-good"></span> Enabled</td>
                        <td>Today</td>
                    </tr>
                </tbody>
            </table>
        </div>
        
        <div class="card">
            <h2>Recent Security Events</h2>
            <table>
                <thead>
                    <tr>
                        <th>Event</th>
                        <th>Severity</th>
                        <th>Date</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Security Governance Framework Implemented</td>
                        <td><span class="status-indicator status-good"></span> Info</td>
                        <td>Today</td>
                        <td>Completed</td>
                    </tr>
                    <tr>
                        <td>Security Policies Created</td>
                        <td><span class="status-indicator status-good"></span> Info</td>
                        <td>Today</td>
                        <td>Completed</td>
                    </tr>
                    <tr>
                        <td>Security Controls Implemented</td>
                        <td><span class="status-indicator status-good"></span> Info</td>
                        <td>Today</td>
                        <td>Completed</td>
                    </tr>
                    <tr>
                        <td>Security Monitoring Configured</td>
                        <td><span class="status-indicator status-good"></span> Info</td>
                        <td>Today</td>
                        <td>Completed</td>
                    </tr>
                    <tr>
                        <td>Security Dashboard Created</td>
                        <td><span class="status-indicator status-good"></span> Info</td>
                        <td>Today</td>
                        <td>Completed</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        // Set last updated time
        document.getElementById('last-updated').textContent = new Date().toLocaleString();
    </script>
</body>
</html>
EOF

# Create a script to update the dashboard
cat > /etc/security_governance/procedures/update_dashboard.sh << 'EOF'
#!/bin/bash

# This script would normally update the dashboard with real data
# For this lab, it just displays a message

echo "In a production environment, this script would:"
echo "1. Collect security metrics from various sources"
echo "2. Update the dashboard with current data"
echo "3. Generate alerts for any compliance issues"
echo
echo "To view the dashboard, open a web browser and navigate to:"
echo "http://localhost/security-governance/"
EOF

chmod +x /etc/security_governance/procedures/update_dashboard.sh
```

### Lab Submission Requirements

To complete this lab, submit the following:

1. **Screenshots**:
   - Screenshot of the directory structure created in Part 1
   - Screenshot of the security dashboard created in Part 4.5
   - Screenshots showing the output of each script you created

2. **Command Output**:
   - Output from running the access review script
   - Output from running the audit report script
   - Output from running the compliance check script
   - Output from running the intrusion detection script

3. **Documentation**:
   - A brief explanation of how each implemented control supports security governance
   - A description of how you would enhance these controls in a production environment
   - A reflection on how the technical controls align with governance principles

### Grading Rubric

**Part 1: Setting Up a Security Governance Framework (25 points)**
- Directory structure correctly created (5 points)
- Policy documents properly formatted and complete (10 points)
- Scripts functional and well-documented (10 points)

**Part 2: Implementing Access Control Governance (25 points)**
- User groups and permissions correctly configured (10 points)
- Sudo access properly restricted based on roles (5 points)
- Access control documentation complete and accurate (5 points)
- Access review script functional (5 points)

**Part 3: Setting Up Security Monitoring and Logging (25 points)**
- System logging correctly configured (5 points)
- Auditd properly configured with appropriate rules (10 points)
- Log rotation configured correctly (5 points)
- Monitoring documentation and scripts functional (5 points)

**Part 4: Implementing Security Policy Enforcement (25 points)**
- Password policy correctly implemented (5 points)
- Account lockout policy properly configured (5 points)
- Compliance check script functional and comprehensive (5 points)
- Firewall correctly configured with appropriate rules (5 points)
- Security dashboard created and accessible (5 points)

### Due Date

This assignment is due by 11:59 PM on [INSERT DATE] via the course learning management system.

### Academic Integrity

Your submitted work must be your own. Properly cite any sources used. Plagiarism or other academic integrity violations will result in disciplinary action according to the ICDFA Academic Integrity Policy.

