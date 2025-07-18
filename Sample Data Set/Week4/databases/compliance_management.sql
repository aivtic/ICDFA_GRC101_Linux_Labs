-- ICDFA GRC101 Week 4 Sample Database
-- Compliance Management and Reporting
-- Sample data for compliance management exercises

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

-- Create Audit Trails table
CREATE TABLE IF NOT EXISTS audit_trails (
    audit_id TEXT PRIMARY KEY,
    event_timestamp DATETIME NOT NULL,
    event_type TEXT NOT NULL,
    user_id TEXT NOT NULL,
    resource_type TEXT,
    resource_id TEXT,
    action_performed TEXT NOT NULL,
    source_ip TEXT,
    user_agent TEXT,
    session_id TEXT,
    event_details TEXT,
    compliance_relevant BOOLEAN DEFAULT FALSE,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Create Compliance Violations table
CREATE TABLE IF NOT EXISTS compliance_violations (
    violation_id TEXT PRIMARY KEY,
    framework_id TEXT NOT NULL,
    requirement_id TEXT NOT NULL,
    violation_date DATE NOT NULL,
    discovery_date DATE,
    violation_type TEXT NOT NULL,
    severity_level TEXT NOT NULL,
    violation_description TEXT NOT NULL,
    root_cause TEXT,
    financial_impact REAL,
    regulatory_impact TEXT,
    violation_status TEXT DEFAULT 'OPEN',
    remediation_plan TEXT,
    remediation_deadline DATE,
    responsible_party TEXT,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (framework_id) REFERENCES compliance_frameworks (framework_id),
    FOREIGN KEY (requirement_id) REFERENCES compliance_requirements (requirement_id)
);

-- Create Compliance Metrics table
CREATE TABLE IF NOT EXISTS compliance_metrics (
    metric_id TEXT PRIMARY KEY,
    framework_id TEXT NOT NULL,
    metric_name TEXT NOT NULL,
    metric_type TEXT NOT NULL,
    metric_value REAL NOT NULL,
    target_value REAL,
    measurement_date DATE NOT NULL,
    measurement_period TEXT,
    metric_description TEXT,
    data_source TEXT,
    calculated_by TEXT,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (framework_id) REFERENCES compliance_frameworks (framework_id)
);

-- Insert sample compliance frameworks
INSERT INTO compliance_frameworks VALUES 
('SOX', 'Sarbanes-Oxley Act', '2002', 'Financial reporting and corporate governance', 'SEC/PCAOB', 'Financial Services', TRUE, '2002-07-30', datetime('now'), datetime('now')),
('GDPR', 'General Data Protection Regulation', '2018', 'Data protection and privacy regulation', 'European Commission', 'All Sectors', TRUE, '2018-05-25', datetime('now'), datetime('now')),
('HIPAA', 'Health Insurance Portability and Accountability Act', '1996', 'Healthcare data protection', 'HHS', 'Healthcare', TRUE, '1996-08-21', datetime('now'), datetime('now')),
('PCI_DSS', 'Payment Card Industry Data Security Standard', '4.0', 'Payment card data protection', 'PCI Security Standards Council', 'Payment Processing', TRUE, '2022-03-31', datetime('now'), datetime('now')),
('ISO27001', 'Information Security Management Systems', '2013', 'Information security management', 'ISO', 'All Sectors', FALSE, '2013-10-01', datetime('now'), datetime('now')),
('NIST_CSF', 'NIST Cybersecurity Framework', '2.0', 'Cybersecurity risk management framework', 'NIST', 'All Sectors', FALSE, '2024-02-26', datetime('now'), datetime('now'));

-- Insert sample compliance requirements
INSERT INTO compliance_requirements VALUES 
('SOX_302', 'SOX', '302', 'Corporate Responsibility for Financial Reports', 'Principal executive and financial officers must certify financial reports', 'Financial Reporting', 'HIGH', 'Implement certification process and controls', 'Review certification documentation and processes', datetime('now')),
('SOX_404', 'SOX', '404', 'Management Assessment of Internal Controls', 'Management must assess and report on internal control over financial reporting', 'Internal Controls', 'HIGH', 'Establish ICFR assessment framework', 'Test control design and operating effectiveness', datetime('now')),
('GDPR_25', 'GDPR', '25', 'Data Protection by Design and by Default', 'Implement appropriate technical and organizational measures', 'Privacy Engineering', 'HIGH', 'Integrate privacy into system design', 'Review system architectures and privacy controls', datetime('now')),
('GDPR_32', 'GDPR', '32', 'Security of Processing', 'Implement appropriate technical and organizational security measures', 'Data Security', 'HIGH', 'Implement encryption, access controls, and monitoring', 'Test security controls and incident response', datetime('now')),
('PCI_3.4', 'PCI_DSS', '3.4', 'Render PAN Unreadable', 'Primary account numbers must be rendered unreadable', 'Data Protection', 'CRITICAL', 'Implement strong cryptography and security protocols', 'Test encryption implementation and key management', datetime('now')),
('ISO_A.9.1.1', 'ISO27001', 'A.9.1.1', 'Access Control Policy', 'An access control policy shall be established, documented and reviewed', 'Access Control', 'HIGH', 'Develop comprehensive access control policy', 'Review policy documentation and implementation', datetime('now')),
('NIST_ID.AM-1', 'NIST_CSF', 'ID.AM-1', 'Physical devices and systems are inventoried', 'Maintain an inventory of physical devices and systems', 'Asset Management', 'MEDIUM', 'Implement asset inventory management system', 'Verify asset inventory accuracy and completeness', datetime('now'));

-- Insert sample policies
INSERT INTO policies VALUES 
('POL_001', 'Information Security Policy', 'Security', 'Information Security', 'Comprehensive information security policy', 'CISO', '2024-01-01', '2024-01-01', '2025-01-01', 'ACTIVE', '/opt/compliance_management/policies/security/info_sec_policy.pdf', datetime('now'), datetime('now')),
('POL_002', 'Data Privacy Policy', 'Privacy', 'Data Protection', 'Data privacy and protection policy', 'DPO', '2024-01-01', '2024-01-01', '2025-01-01', 'ACTIVE', '/opt/compliance_management/policies/privacy/data_privacy_policy.pdf', datetime('now'), datetime('now')),
('POL_003', 'Access Control Policy', 'Security', 'Access Management', 'User access control and management policy', 'IT Security Manager', '2024-01-01', '2024-01-01', '2025-01-01', 'ACTIVE', '/opt/compliance_management/policies/security/access_control_policy.pdf', datetime('now'), datetime('now')),
('POL_004', 'Financial Reporting Policy', 'Financial', 'Financial Controls', 'Financial reporting and internal controls policy', 'CFO', '2024-01-01', '2024-01-01', '2025-01-01', 'ACTIVE', '/opt/compliance_management/policies/financial/financial_reporting_policy.pdf', datetime('now'), datetime('now'));

-- Insert sample controls
INSERT INTO controls VALUES 
('CTRL_001', 'Multi-Factor Authentication', 'Technical', 'Access Control', 'Implement MFA for all privileged accounts', 'IMPLEMENTED', 'IT Security Team', '2024-01-15', 'Monthly', '2024-01-15', 'PASS', 9, datetime('now'), datetime('now')),
('CTRL_002', 'Data Encryption at Rest', 'Technical', 'Data Protection', 'Encrypt sensitive data stored in databases and file systems', 'IMPLEMENTED', 'Database Team', '2024-01-10', 'Quarterly', '2024-01-10', 'PASS', 8, datetime('now'), datetime('now')),
('CTRL_003', 'Security Awareness Training', 'Administrative', 'Human Resources', 'Mandatory security awareness training for all employees', 'IMPLEMENTED', 'HR Department', '2024-01-05', 'Annually', '2024-01-05', 'PASS', 7, datetime('now'), datetime('now')),
('CTRL_004', 'Firewall Configuration', 'Technical', 'Network Security', 'Configure and maintain network firewalls', 'IMPLEMENTED', 'Network Team', '2024-01-08', 'Monthly', '2024-01-08', 'PASS', 8, datetime('now'), datetime('now')),
('CTRL_005', 'Financial Close Process', 'Process', 'Financial Controls', 'Monthly financial close process with management review', 'IMPLEMENTED', 'Finance Team', '2024-01-12', 'Monthly', '2024-01-12', 'PASS', 9, datetime('now'), datetime('now')),
('CTRL_006', 'Change Management', 'Administrative', 'IT Operations', 'Formal change management process for IT systems', 'IMPLEMENTED', 'IT Operations', '2024-01-20', 'Continuous', '2024-01-20', 'PASS', 8, datetime('now'), datetime('now'));

-- Insert sample compliance assessments
INSERT INTO compliance_assessments VALUES 
('ASSESS_001', 'SOX', 'Internal Assessment', 'Financial Reporting Systems', 'Internal Audit Team', '2024-01-15', '2023-10-01', '2023-12-31', 92, 'COMPLIANT', 'Strong financial controls in place, minor documentation gaps', 'Enhance control documentation and testing procedures', '2024-04-15', 'ACTIVE'),
('ASSESS_002', 'GDPR', 'External Assessment', 'Data Processing Activities', 'Privacy Consulting Firm', '2024-01-10', '2023-07-01', '2023-12-31', 85, 'PARTIALLY_COMPLIANT', 'Good privacy controls, some gaps in data subject rights', 'Implement automated data subject request handling', '2024-07-10', 'ACTIVE'),
('ASSESS_003', 'PCI_DSS', 'QSA Assessment', 'Cardholder Data Environment', 'Qualified Security Assessor', '2024-01-20', '2023-01-01', '2023-12-31', 78, 'NON_COMPLIANT', 'Network segmentation issues, vulnerability management gaps', 'Implement network segmentation and enhance vulnerability scanning', '2024-04-20', 'ACTIVE'),
('ASSESS_004', 'ISO27001', 'Certification Audit', 'Information Security Management System', 'Certification Body', '2024-01-05', '2023-01-01', '2023-12-31', 88, 'COMPLIANT', 'ISMS effectively implemented, some minor non-conformities', 'Address minor non-conformities and improve documentation', '2025-01-05', 'ACTIVE'),
('ASSESS_005', 'HIPAA', 'Risk Assessment', 'Healthcare Data Systems', 'Healthcare Compliance Specialist', '2024-01-25', '2023-01-01', '2023-12-31', 94, 'COMPLIANT', 'Strong PHI protection controls, excellent documentation', 'Continue current practices and monitor for changes', '2025-01-25', 'ACTIVE');

-- Insert sample assessment results
INSERT INTO assessment_results VALUES 
('RESULT_001', 'ASSESS_001', 'SOX_302', 'CTRL_005', 'COMPLIANT', 100, 'Management certification process documented and tested', NULL, NULL, NULL, 'CFO', 'Certification process operating effectively'),
('RESULT_002', 'ASSESS_001', 'SOX_404', 'CTRL_005', 'COMPLIANT', 95, 'ICFR assessment framework implemented and tested', 'Minor documentation gaps', 'Enhance control documentation', '30 days', 'Internal Audit', 'Controls operating effectively with minor improvements needed'),
('RESULT_003', 'ASSESS_002', 'GDPR_25', 'CTRL_002', 'COMPLIANT', 90, 'Privacy by design implemented in system architecture', NULL, NULL, NULL, 'DPO', 'Privacy controls effectively integrated'),
('RESULT_004', 'ASSESS_002', 'GDPR_32', 'CTRL_001', 'PARTIALLY_COMPLIANT', 70, 'Security measures implemented but some gaps', 'Data subject request automation needed', 'Implement automated DSR handling', '90 days', 'IT Security Manager', 'Security controls need enhancement'),
('RESULT_005', 'ASSESS_003', 'PCI_3.4', 'CTRL_002', 'NON_COMPLIANT', 40, 'Encryption implemented but key management issues', 'Weak key management practices', 'Implement proper key management', '60 days', 'Security Team', 'Significant improvements required'),
('RESULT_006', 'ASSESS_004', 'ISO_A.9.1.1', 'CTRL_003', 'COMPLIANT', 85, 'Access control policy documented and implemented', 'Policy review frequency could be improved', 'Increase review frequency', '30 days', 'IT Security Manager', 'Policy effectively implemented'),
('RESULT_007', 'ASSESS_005', 'HIPAA_164_308', 'CTRL_003', 'COMPLIANT', 95, 'Administrative safeguards properly implemented', NULL, NULL, NULL, 'Privacy Officer', 'Excellent implementation of administrative controls');

-- Insert sample compliance evidence
INSERT INTO compliance_evidence VALUES 
('EVID_001', 'ASSESS_001', 'SOX_302', 'DOCUMENT', 'Management certification letters for Q4 2023', '/evidence/sox/mgmt_certifications_q4_2023.pdf', '2024-01-15 10:30:00', 'Internal Auditor', 'sha256:a1b2c3d4e5f6...', '2031-01-15', 'CONFIDENTIAL'),
('EVID_002', 'ASSESS_001', 'SOX_404', 'DOCUMENT', 'ICFR assessment documentation', '/evidence/sox/icfr_assessment_2023.pdf', '2024-01-15 11:00:00', 'Internal Auditor', 'sha256:b2c3d4e5f6g7...', '2031-01-15', 'CONFIDENTIAL'),
('EVID_003', 'ASSESS_002', 'GDPR_25', 'SCREENSHOT', 'Privacy settings in application configuration', '/evidence/gdpr/privacy_config_screenshot.png', '2024-01-10 14:15:00', 'Privacy Analyst', 'sha256:c3d4e5f6g7h8...', '2031-01-10', 'INTERNAL'),
('EVID_004', 'ASSESS_002', 'GDPR_32', 'LOG_FILE', 'Security monitoring logs for December 2023', '/evidence/gdpr/security_logs_dec_2023.log', '2024-01-10 15:30:00', 'Security Analyst', 'sha256:d4e5f6g7h8i9...', '2031-01-10', 'CONFIDENTIAL'),
('EVID_005', 'ASSESS_003', 'PCI_3.4', 'SCAN_REPORT', 'Vulnerability scan report for CDE', '/evidence/pci/vuln_scan_cde_jan_2024.pdf', '2024-01-20 09:45:00', 'Security Assessor', 'sha256:e5f6g7h8i9j0...', '2031-01-20', 'CONFIDENTIAL'),
('EVID_006', 'ASSESS_004', 'ISO_A.9.1.1', 'DOCUMENT', 'Access control policy document v2.1', '/evidence/iso/access_control_policy_v2.1.pdf', '2024-01-05 13:20:00', 'ISO Auditor', 'sha256:f6g7h8i9j0k1...', '2031-01-05', 'INTERNAL');

-- Insert sample audit trails
INSERT INTO audit_trails VALUES 
('AUDIT_001', '2024-01-15 08:30:15', 'LOGIN', 'john.doe@acme.com', 'USER_ACCOUNT', 'john.doe', 'Successful login', '192.168.1.100', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', 'sess_abc123', 'User logged in successfully', TRUE, datetime('now')),
('AUDIT_002', '2024-01-15 08:35:22', 'DATA_ACCESS', 'john.doe@acme.com', 'CUSTOMER_DATA', 'cust_12345', 'Accessed customer record', '192.168.1.100', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', 'sess_abc123', 'Viewed customer profile for support case', TRUE, datetime('now')),
('AUDIT_003', '2024-01-15 09:15:45', 'POLICY_UPDATE', 'admin@acme.com', 'POLICY', 'POL_001', 'Updated information security policy', '192.168.1.50', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', 'sess_def456', 'Policy version updated to 2.2', TRUE, datetime('now')),
('AUDIT_004', '2024-01-15 10:22:33', 'CONTROL_TEST', 'auditor@acme.com', 'CONTROL', 'CTRL_001', 'Performed MFA control testing', '192.168.1.75', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', 'sess_ghi789', 'MFA control test completed successfully', TRUE, datetime('now')),
('AUDIT_005', '2024-01-15 11:45:12', 'ASSESSMENT_CREATE', 'compliance@acme.com', 'ASSESSMENT', 'ASSESS_006', 'Created new compliance assessment', '192.168.1.25', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', 'sess_jkl012', 'NIST CSF assessment created for Q1 2024', TRUE, datetime('now')),
('AUDIT_006', '2024-01-15 14:30:55', 'EVIDENCE_UPLOAD', 'analyst@acme.com', 'EVIDENCE', 'EVID_007', 'Uploaded compliance evidence', '192.168.1.125', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', 'sess_mno345', 'Uploaded firewall configuration evidence', TRUE, datetime('now')),
('AUDIT_007', '2024-01-15 15:20:18', 'VIOLATION_REPORT', 'security@acme.com', 'VIOLATION', 'VIOL_001', 'Reported compliance violation', '192.168.1.150', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', 'sess_pqr678', 'Reported GDPR data retention violation', TRUE, datetime('now')),
('AUDIT_008', '2024-01-15 16:10:42', 'LOGOUT', 'john.doe@acme.com', 'USER_ACCOUNT', 'john.doe', 'User logout', '192.168.1.100', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', 'sess_abc123', 'User logged out normally', TRUE, datetime('now'));

-- Insert sample compliance violations
INSERT INTO compliance_violations VALUES 
('VIOL_001', 'GDPR', 'GDPR_25', '2024-01-12', '2024-01-15', 'Data Retention', 'MEDIUM', 'Customer data retained beyond required retention period', 'Automated data deletion process not implemented', 5000, 'Potential regulatory fine', 'OPEN', 'Implement automated data retention and deletion process', '2024-03-15', 'Data Protection Officer'),
('VIOL_002', 'PCI_DSS', 'PCI_3.4', '2024-01-08', '2024-01-10', 'Encryption', 'HIGH', 'Cardholder data found unencrypted in log files', 'Insufficient data masking in logging system', 25000, 'Potential PCI DSS fine and card brand penalties', 'IN_PROGRESS', 'Implement proper data masking and log sanitization', '2024-02-08', 'Security Team'),
('VIOL_003', 'SOX', 'SOX_404', '2024-01-05', '2024-01-08', 'Access Control', 'LOW', 'Excessive user privileges in financial system', 'Quarterly access review not performed', 0, 'Internal control deficiency', 'CLOSED', 'Performed access review and removed excessive privileges', '2024-01-20', 'IT Security Manager'),
('VIOL_004', 'HIPAA', 'HIPAA_164_308', '2024-01-20', '2024-01-22', 'Administrative Safeguards', 'MEDIUM', 'Incomplete security awareness training records', 'Training completion not properly tracked', 10000, 'Potential HIPAA violation', 'OPEN', 'Complete training records and implement tracking system', '2024-02-22', 'HR Department');

-- Insert sample compliance metrics
INSERT INTO compliance_metrics VALUES 
('METRIC_001', 'SOX', 'Control Effectiveness Rate', 'PERCENTAGE', 94.5, 95.0, '2024-01-15', 'Q4_2023', 'Percentage of SOX controls operating effectively', 'Internal Audit System', 'Internal Auditor'),
('METRIC_002', 'GDPR', 'Data Subject Request Response Time', 'DAYS', 18.5, 30.0, '2024-01-15', 'Q4_2023', 'Average time to respond to data subject requests', 'Privacy Management System', 'Privacy Officer'),
('METRIC_003', 'PCI_DSS', 'Vulnerability Remediation Time', 'DAYS', 25.3, 30.0, '2024-01-15', 'Q4_2023', 'Average time to remediate high-risk vulnerabilities', 'Vulnerability Management System', 'Security Manager'),
('METRIC_004', 'ISO27001', 'Security Incident Response Time', 'HOURS', 2.8, 4.0, '2024-01-15', 'Q4_2023', 'Average time to respond to security incidents', 'SIEM System', 'Security Operations Center'),
('METRIC_005', 'HIPAA', 'PHI Access Compliance Rate', 'PERCENTAGE', 98.7, 99.0, '2024-01-15', 'Q4_2023', 'Percentage of PHI access events compliant with minimum necessary', 'Access Management System', 'Privacy Officer'),
('METRIC_006', 'NIST_CSF', 'Cybersecurity Maturity Score', 'SCORE', 3.2, 4.0, '2024-01-15', 'Q4_2023', 'Overall cybersecurity maturity score (1-5 scale)', 'GRC Platform', 'CISO');

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_frameworks_sector ON compliance_frameworks(industry_sector);
CREATE INDEX IF NOT EXISTS idx_requirements_framework ON compliance_requirements(framework_id);
CREATE INDEX IF NOT EXISTS idx_policies_type ON policies(policy_type);
CREATE INDEX IF NOT EXISTS idx_controls_status ON controls(implementation_status);
CREATE INDEX IF NOT EXISTS idx_assessments_date ON compliance_assessments(assessment_date);
CREATE INDEX IF NOT EXISTS idx_assessments_framework ON compliance_assessments(framework_id);
CREATE INDEX IF NOT EXISTS idx_results_assessment ON assessment_results(assessment_id);
CREATE INDEX IF NOT EXISTS idx_evidence_assessment ON compliance_evidence(assessment_id);
CREATE INDEX IF NOT EXISTS idx_audit_timestamp ON audit_trails(event_timestamp);
CREATE INDEX IF NOT EXISTS idx_audit_user ON audit_trails(user_id);
CREATE INDEX IF NOT EXISTS idx_audit_compliance ON audit_trails(compliance_relevant);
CREATE INDEX IF NOT EXISTS idx_violations_framework ON compliance_violations(framework_id);
CREATE INDEX IF NOT EXISTS idx_violations_status ON compliance_violations(violation_status);
CREATE INDEX IF NOT EXISTS idx_metrics_framework ON compliance_metrics(framework_id);
CREATE INDEX IF NOT EXISTS idx_metrics_date ON compliance_metrics(measurement_date);

-- Create views for common compliance queries
CREATE VIEW IF NOT EXISTS active_policies AS
SELECT * FROM policies WHERE status = 'ACTIVE';

CREATE VIEW IF NOT EXISTS implemented_controls AS
SELECT * FROM controls WHERE implementation_status = 'IMPLEMENTED';

CREATE VIEW IF NOT EXISTS mandatory_frameworks AS
SELECT * FROM compliance_frameworks WHERE mandatory = TRUE;

CREATE VIEW IF NOT EXISTS non_compliant_assessments AS
SELECT * FROM compliance_assessments WHERE compliance_status = 'NON_COMPLIANT';

CREATE VIEW IF NOT EXISTS open_violations AS
SELECT * FROM compliance_violations WHERE violation_status = 'OPEN';

CREATE VIEW IF NOT EXISTS recent_audit_events AS
SELECT * FROM audit_trails 
WHERE compliance_relevant = TRUE 
AND event_timestamp >= datetime('now', '-30 days')
ORDER BY event_timestamp DESC;

CREATE VIEW IF NOT EXISTS compliance_dashboard AS
SELECT 
    cf.framework_name,
    ca.compliance_status,
    ca.overall_compliance_score,
    ca.assessment_date,
    COUNT(cv.violation_id) as open_violations
FROM compliance_frameworks cf
LEFT JOIN compliance_assessments ca ON cf.framework_id = ca.framework_id
LEFT JOIN compliance_violations cv ON cf.framework_id = cv.framework_id AND cv.violation_status = 'OPEN'
WHERE ca.status = 'ACTIVE'
GROUP BY cf.framework_id, cf.framework_name, ca.compliance_status, ca.overall_compliance_score, ca.assessment_date;

CREATE VIEW IF NOT EXISTS control_effectiveness_summary AS
SELECT 
    c.control_family,
    COUNT(c.control_id) as total_controls,
    AVG(c.effectiveness_rating) as avg_effectiveness,
    SUM(CASE WHEN c.implementation_status = 'IMPLEMENTED' THEN 1 ELSE 0 END) as implemented_controls,
    SUM(CASE WHEN c.test_results = 'PASS' THEN 1 ELSE 0 END) as passing_controls
FROM controls c
GROUP BY c.control_family;

CREATE VIEW IF NOT EXISTS compliance_metrics_summary AS
SELECT 
    cf.framework_name,
    cm.metric_name,
    cm.metric_value,
    cm.target_value,
    CASE 
        WHEN cm.metric_value >= cm.target_value THEN 'MEETING_TARGET'
        WHEN cm.metric_value >= cm.target_value * 0.9 THEN 'NEAR_TARGET'
        ELSE 'BELOW_TARGET'
    END as performance_status,
    cm.measurement_date
FROM compliance_metrics cm
JOIN compliance_frameworks cf ON cm.framework_id = cf.framework_id
WHERE cm.measurement_date = (
    SELECT MAX(measurement_date) 
    FROM compliance_metrics cm2 
    WHERE cm2.framework_id = cm.framework_id 
    AND cm2.metric_name = cm.metric_name
);

