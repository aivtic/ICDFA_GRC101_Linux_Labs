# Week 1 Linux Lab: GRC Frameworks and Principles
## Instructor Guide

**International Cybersecurity and Digital Forensics Academy (ICDFA)**  
**Course: GRC101 - Introduction to Governance, Risk, and Compliance**  
**Lab Duration: 3 hours**  
**Difficulty Level: Beginner to Intermediate**

---

## Lab Overview

This hands-on lab introduces students to practical implementation of GRC frameworks using Linux operating system tools and commands. Students will learn to use Linux for governance documentation, risk assessment data collection, and compliance monitoring through practical exercises that reinforce theoretical concepts covered in Week 1.

### Learning Objectives

By the end of this lab, students will be able to:
1. Use Linux command-line tools for GRC documentation and data management
2. Implement basic governance controls using Linux file permissions and access controls
3. Create risk assessment templates and data collection scripts
4. Set up compliance monitoring using Linux system tools
5. Understand how Linux security features support GRC frameworks

### Prerequisites

- Basic Linux command-line knowledge
- Understanding of file systems and permissions
- Access to Linux terminal (Ubuntu 22.04 or similar)
- Text editor familiarity (nano, vim, or gedit)

---

## Lab Environment Setup

### Required Software
- Linux OS (Ubuntu 22.04 LTS recommended)
- Text editors: nano, vim, gedit
- System monitoring tools: htop, iotop, netstat
- Security tools: fail2ban, ufw, auditd
- Documentation tools: pandoc, markdown processors

### Pre-Lab Preparation
1. Ensure all students have access to Linux systems
2. Verify required packages are installed
3. Create lab user accounts with appropriate permissions
4. Prepare sample data files for exercises
5. Set up shared directories for collaborative exercises

### Installation Commands
```bash
# Update system packages
sudo apt update && sudo apt upgrade -y

# Install required tools
sudo apt install -y htop iotop net-tools fail2ban ufw auditd pandoc tree

# Install text processing tools
sudo apt install -y jq xmlstarlet csvkit

# Install security monitoring tools
sudo apt install -y rkhunter chkrootkit lynis
```

---

## Exercise 1: Governance Documentation Framework (45 minutes)

### Instructor Notes
This exercise teaches students to create and manage governance documentation using Linux file systems and tools. Emphasize the importance of proper documentation structure and access controls in governance frameworks.

### Learning Outcomes
- Understand governance documentation hierarchy
- Implement access controls for sensitive documents
- Create standardized documentation templates
- Use version control for governance documents

### Setup Instructions
1. Create base directory structure for governance documents
2. Set up user groups for different access levels
3. Prepare sample policy templates
4. Configure file permissions according to governance requirements

### Step-by-Step Walkthrough

#### Part A: Creating Governance Directory Structure
```bash
# Create main governance directory
sudo mkdir -p /opt/grc/governance/{policies,procedures,standards,guidelines}
sudo mkdir -p /opt/grc/governance/{board,executive,operational}
sudo mkdir -p /opt/grc/governance/templates

# Set ownership and permissions
sudo chown -R root:grc-admin /opt/grc/governance
sudo chmod -R 750 /opt/grc/governance
```

#### Part B: User and Group Management
```bash
# Create GRC-specific groups
sudo groupadd grc-admin
sudo groupadd grc-auditor
sudo groupadd grc-user

# Add users to appropriate groups
sudo usermod -a -G grc-admin instructor
sudo usermod -a -G grc-user student
```

#### Part C: Policy Template Creation
Students will create standardized policy templates using Linux text processing tools.

### Assessment Criteria
- Correct directory structure implementation
- Appropriate permission settings
- Quality of documentation templates
- Understanding of access control principles

### Common Issues and Solutions
1. **Permission Denied Errors**: Check group membership and directory permissions
2. **Template Formatting**: Ensure consistent markdown formatting
3. **Access Control**: Verify umask settings and default permissions

---

## Exercise 2: Risk Assessment Data Collection (60 minutes)

### Instructor Notes
This exercise demonstrates how Linux system tools can be used for risk assessment data collection and analysis. Students will learn to gather system information, analyze logs, and create risk assessment reports.

### Learning Outcomes
- Use Linux commands for system information gathering
- Analyze system logs for risk indicators
- Create automated risk assessment scripts
- Generate risk reports using command-line tools

### Setup Instructions
1. Prepare sample log files with various risk scenarios
2. Create baseline system configuration files
3. Set up monitoring scripts for demonstration
4. Prepare risk assessment templates

### Step-by-Step Walkthrough

#### Part A: System Information Collection
```bash
# Create risk assessment directory
mkdir -p ~/risk_assessment/{data,reports,scripts}

# Collect system information
uname -a > ~/risk_assessment/data/system_info.txt
lscpu > ~/risk_assessment/data/cpu_info.txt
free -h > ~/risk_assessment/data/memory_info.txt
df -h > ~/risk_assessment/data/disk_usage.txt
```

#### Part B: Security Assessment Scripts
Students will create scripts to automate risk assessment data collection.

```bash
#!/bin/bash
# Risk Assessment Data Collection Script
# File: ~/risk_assessment/scripts/collect_risk_data.sh

echo "=== GRC Risk Assessment Data Collection ===" > ~/risk_assessment/reports/risk_report.txt
echo "Date: $(date)" >> ~/risk_assessment/reports/risk_report.txt
echo "" >> ~/risk_assessment/reports/risk_report.txt

# System vulnerabilities check
echo "=== System Vulnerabilities ===" >> ~/risk_assessment/reports/risk_report.txt
sudo apt list --upgradable 2>/dev/null | grep -v "WARNING" >> ~/risk_assessment/reports/risk_report.txt
```

#### Part C: Log Analysis for Risk Indicators
```bash
# Analyze authentication logs
sudo grep "Failed password" /var/log/auth.log | tail -20 > ~/risk_assessment/data/failed_logins.txt

# Check for suspicious network connections
netstat -tuln > ~/risk_assessment/data/network_connections.txt

# Review system processes
ps aux --sort=-%cpu | head -20 > ~/risk_assessment/data/top_processes.txt
```

### Assessment Criteria
- Accuracy of data collection scripts
- Quality of risk analysis
- Proper use of Linux commands
- Understanding of risk indicators

### Troubleshooting Guide
1. **Log Access Issues**: Ensure proper sudo permissions
2. **Script Execution**: Check file permissions and shebang lines
3. **Data Format**: Verify output formatting and file paths

---

## Exercise 3: Compliance Monitoring Setup (75 minutes)

### Instructor Notes
This comprehensive exercise teaches students to implement compliance monitoring using Linux tools. Focus on practical implementation of compliance controls and automated monitoring.

### Learning Outcomes
- Configure system auditing for compliance
- Set up automated compliance checks
- Create compliance reporting mechanisms
- Implement access control monitoring

### Setup Instructions
1. Configure auditd for system auditing
2. Set up log rotation and retention policies
3. Create compliance check scripts
4. Prepare compliance reporting templates

### Step-by-Step Walkthrough

#### Part A: System Auditing Configuration
```bash
# Configure auditd for compliance monitoring
sudo systemctl enable auditd
sudo systemctl start auditd

# Create audit rules for compliance
sudo auditctl -w /etc/passwd -p wa -k user_management
sudo auditctl -w /etc/group -p wa -k group_management
sudo auditctl -w /etc/shadow -p wa -k password_changes
```

#### Part B: Compliance Check Scripts
Students will create automated compliance verification scripts.

```bash
#!/bin/bash
# Compliance Check Script
# File: ~/compliance/scripts/compliance_check.sh

COMPLIANCE_DIR="$HOME/compliance"
REPORT_FILE="$COMPLIANCE_DIR/reports/compliance_report_$(date +%Y%m%d).txt"

mkdir -p "$COMPLIANCE_DIR/reports"

echo "=== GRC Compliance Check Report ===" > "$REPORT_FILE"
echo "Generated: $(date)" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Check password policy compliance
echo "=== Password Policy Compliance ===" >> "$REPORT_FILE"
grep "^PASS_MAX_DAYS" /etc/login.defs >> "$REPORT_FILE"
grep "^PASS_MIN_DAYS" /etc/login.defs >> "$REPORT_FILE"
```

#### Part C: Access Control Monitoring
```bash
# Monitor file access patterns
sudo find /etc -type f -name "*.conf" -exec ls -la {} \; > ~/compliance/data/config_permissions.txt

# Check for unauthorized SUID files
sudo find / -type f -perm -4000 2>/dev/null > ~/compliance/data/suid_files.txt

# Monitor user login patterns
last -n 50 > ~/compliance/data/login_history.txt
```

### Assessment Criteria
- Proper auditd configuration
- Effective compliance check implementation
- Quality of monitoring scripts
- Understanding of compliance requirements

### Advanced Extensions
1. Integration with external compliance frameworks
2. Automated report generation and distribution
3. Real-time alerting for compliance violations
4. Dashboard creation for compliance metrics

---

## Exercise 4: GRC Framework Implementation (60 minutes)

### Instructor Notes
This capstone exercise integrates all previous exercises into a comprehensive GRC framework implementation. Students will create a complete GRC system using Linux tools.

### Learning Outcomes
- Integrate governance, risk, and compliance components
- Create comprehensive GRC documentation system
- Implement automated GRC processes
- Demonstrate understanding of GRC framework principles

### Setup Instructions
1. Prepare integrated GRC directory structure
2. Create sample organizational policies
3. Set up automated workflow scripts
4. Prepare assessment rubrics

### Step-by-Step Walkthrough

#### Part A: Integrated GRC System Setup
```bash
# Create comprehensive GRC structure
sudo mkdir -p /opt/grc/{governance,risk,compliance}/{policies,procedures,data,reports,scripts}

# Set up proper permissions
sudo chown -R root:grc-admin /opt/grc
sudo chmod -R 750 /opt/grc

# Create symbolic links for easy access
ln -s /opt/grc ~/grc_system
```

#### Part B: Automated GRC Workflow
Students will create a master script that integrates all GRC components.

```bash
#!/bin/bash
# Master GRC Framework Script
# File: /opt/grc/scripts/grc_master.sh

GRC_BASE="/opt/grc"
DATE=$(date +%Y%m%d_%H%M%S)

# Create daily GRC report
echo "=== Daily GRC Framework Report ===" > "$GRC_BASE/reports/daily_grc_$DATE.txt"

# Run governance checks
echo "Running governance documentation review..."
find "$GRC_BASE/governance" -name "*.md" -mtime -1 >> "$GRC_BASE/reports/daily_grc_$DATE.txt"

# Execute risk assessment
echo "Executing risk assessment..."
bash "$GRC_BASE/risk/scripts/risk_assessment.sh" >> "$GRC_BASE/reports/daily_grc_$DATE.txt"

# Perform compliance checks
echo "Performing compliance verification..."
bash "$GRC_BASE/compliance/scripts/compliance_check.sh" >> "$GRC_BASE/reports/daily_grc_$DATE.txt"
```

#### Part C: GRC Dashboard Creation
```bash
# Create simple text-based GRC dashboard
#!/bin/bash
# GRC Dashboard Script
# File: /opt/grc/scripts/grc_dashboard.sh

clear
echo "=========================================="
echo "    ICDFA GRC Framework Dashboard"
echo "=========================================="
echo "Last Updated: $(date)"
echo ""

# Display governance status
echo "GOVERNANCE STATUS:"
echo "- Active Policies: $(find /opt/grc/governance/policies -name "*.md" | wc -l)"
echo "- Recent Updates: $(find /opt/grc/governance -name "*.md" -mtime -7 | wc -l)"
echo ""

# Display risk status
echo "RISK MANAGEMENT STATUS:"
echo "- Risk Assessments: $(find /opt/grc/risk/data -name "*risk*" | wc -l)"
echo "- High Risk Items: $(grep -r "HIGH" /opt/grc/risk/data 2>/dev/null | wc -l)"
echo ""

# Display compliance status
echo "COMPLIANCE STATUS:"
echo "- Compliance Checks: $(find /opt/grc/compliance/reports -name "*compliance*" | wc -l)"
echo "- Failed Checks: $(grep -r "FAIL" /opt/grc/compliance/reports 2>/dev/null | wc -l)"
```

### Assessment Criteria
- Integration of all GRC components
- Quality of automation scripts
- Effectiveness of reporting mechanisms
- Demonstration of GRC framework understanding

### Final Project Requirements
Students must demonstrate:
1. Complete GRC system implementation
2. Automated workflow execution
3. Comprehensive reporting capability
4. Understanding of Linux security principles

---

## Assessment and Grading

### Grading Rubric (100 points total)

#### Exercise 1: Governance Documentation (20 points)
- Directory structure (5 points)
- Permission configuration (5 points)
- Template quality (5 points)
- Documentation completeness (5 points)

#### Exercise 2: Risk Assessment (25 points)
- Data collection accuracy (8 points)
- Script functionality (8 points)
- Analysis quality (5 points)
- Report generation (4 points)

#### Exercise 3: Compliance Monitoring (30 points)
- Audit configuration (10 points)
- Monitoring scripts (10 points)
- Compliance checks (5 points)
- Reporting mechanism (5 points)

#### Exercise 4: GRC Integration (25 points)
- System integration (10 points)
- Automation quality (8 points)
- Dashboard functionality (4 points)
- Overall understanding (3 points)

### Assessment Methods
1. **Practical Demonstration**: Students demonstrate working systems
2. **Code Review**: Instructor reviews scripts and configurations
3. **Documentation Review**: Assessment of created documentation
4. **Oral Examination**: Questions about implementation decisions

### Common Student Challenges
1. **Permission Issues**: Students often struggle with Linux permissions
2. **Script Debugging**: Syntax errors and logic issues in scripts
3. **Integration Complexity**: Difficulty connecting different components
4. **Documentation Quality**: Inconsistent or incomplete documentation

### Remediation Strategies
1. **Peer Programming**: Pair students for collaborative problem-solving
2. **Incremental Building**: Break complex tasks into smaller steps
3. **Template Provision**: Provide script templates for struggling students
4. **Extended Lab Time**: Offer additional lab sessions for completion

---

## Additional Resources

### Recommended Reading
1. Linux System Administration Handbook
2. NIST Cybersecurity Framework Implementation Guide
3. ISO 27001 Implementation Guidelines
4. Linux Security and Hardening Guide

### Online Resources
1. Linux Documentation Project (tldp.org)
2. NIST Special Publications (csrc.nist.gov)
3. SANS Linux Security Resources
4. Ubuntu Security Documentation

### Tools and Utilities
1. **System Monitoring**: htop, iotop, netstat, ss
2. **Security Tools**: fail2ban, ufw, auditd, rkhunter
3. **Documentation**: pandoc, markdown, git
4. **Automation**: bash, cron, systemd

### Lab Extension Ideas
1. **Advanced Scripting**: Python integration for complex analysis
2. **Database Integration**: Store GRC data in databases
3. **Web Interface**: Create web-based GRC dashboard
4. **Integration Testing**: Connect with external GRC tools

---

## Troubleshooting Guide

### Common Technical Issues

#### Permission Problems
```bash
# Fix common permission issues
sudo chown -R user:group /path/to/directory
sudo chmod -R 755 /path/to/directory
```

#### Script Execution Issues
```bash
# Make scripts executable
chmod +x script_name.sh

# Check script syntax
bash -n script_name.sh
```

#### Service Configuration Problems
```bash
# Check service status
sudo systemctl status service_name

# View service logs
sudo journalctl -u service_name
```

### Student Support Strategies
1. **Pre-Lab Checklist**: Ensure all prerequisites are met
2. **Buddy System**: Pair experienced with novice students
3. **Progressive Disclosure**: Reveal complexity gradually
4. **Checkpoint Reviews**: Regular progress assessments

### Emergency Procedures
1. **System Recovery**: Backup and restore procedures
2. **Data Loss Prevention**: Regular backup strategies
3. **Security Incidents**: Response procedures for lab environment
4. **Technical Support**: Escalation procedures for complex issues

---

## Post-Lab Activities

### Reflection Questions
1. How do Linux security features support GRC frameworks?
2. What are the advantages of command-line tools for GRC implementation?
3. How can automation improve GRC processes?
4. What challenges did you encounter and how did you resolve them?

### Follow-Up Assignments
1. **Research Project**: Investigate enterprise GRC tools that use Linux
2. **Case Study**: Analyze a real-world GRC implementation
3. **Tool Comparison**: Compare Linux tools with commercial GRC solutions
4. **Process Improvement**: Suggest enhancements to lab procedures

### Preparation for Next Week
1. Review regulatory compliance requirements
2. Research Linux tools for compliance monitoring
3. Prepare questions about regulatory frameworks
4. Install additional tools for Week 2 lab

---

*This instructor guide provides comprehensive support for delivering effective hands-on GRC education using Linux platforms. Regular updates and improvements based on student feedback and industry developments are recommended.*

