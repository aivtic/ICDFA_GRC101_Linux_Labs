-- ICDFA GRC101 Week 1 Sample Database
-- GRC Frameworks and Principles Implementation
-- Sample data for hands-on exercises

-- Create GRC Frameworks table
CREATE TABLE IF NOT EXISTS grc_frameworks (
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

-- Create Governance Structures table
CREATE TABLE IF NOT EXISTS governance_structures (
    structure_id TEXT PRIMARY KEY,
    structure_name TEXT NOT NULL,
    structure_type TEXT NOT NULL,
    description TEXT,
    responsible_party TEXT,
    reporting_frequency TEXT,
    effectiveness_rating INTEGER,
    last_review_date DATE,
    next_review_date DATE,
    status TEXT DEFAULT 'ACTIVE',
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP
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

-- Create Framework Mappings table
CREATE TABLE IF NOT EXISTS framework_mappings (
    mapping_id TEXT PRIMARY KEY,
    source_framework TEXT NOT NULL,
    target_framework TEXT NOT NULL,
    source_control TEXT NOT NULL,
    target_control TEXT NOT NULL,
    mapping_type TEXT NOT NULL,
    confidence_level TEXT,
    mapping_notes TEXT,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (source_framework) REFERENCES grc_frameworks (framework_id),
    FOREIGN KEY (target_framework) REFERENCES grc_frameworks (framework_id)
);

-- Insert sample GRC frameworks
INSERT INTO grc_frameworks VALUES 
('NIST_CSF', 'NIST Cybersecurity Framework', '2.0', 'Comprehensive cybersecurity framework for critical infrastructure', 'NIST', 'All Sectors', FALSE, '2024-02-26', datetime('now'), datetime('now')),
('ISO27001', 'Information Security Management Systems', '2022', 'International standard for information security management', 'ISO', 'All Sectors', FALSE, '2022-10-01', datetime('now'), datetime('now')),
('COBIT', 'Control Objectives for Information and Related Technologies', '2019', 'Framework for governance and management of enterprise IT', 'ISACA', 'All Sectors', FALSE, '2018-11-01', datetime('now'), datetime('now')),
('COSO', 'Committee of Sponsoring Organizations', '2013', 'Internal control framework for financial reporting', 'COSO', 'Financial Services', FALSE, '2013-05-14', datetime('now'), datetime('now')),
('SOX', 'Sarbanes-Oxley Act', '2002', 'Financial reporting and corporate governance', 'SEC/PCAOB', 'Public Companies', TRUE, '2002-07-30', datetime('now'), datetime('now')),
('GDPR', 'General Data Protection Regulation', '2018', 'Data protection and privacy regulation', 'European Commission', 'All Sectors', TRUE, '2018-05-25', datetime('now'), datetime('now')),
('HIPAA', 'Health Insurance Portability and Accountability Act', '1996', 'Healthcare data protection', 'HHS', 'Healthcare', TRUE, '1996-08-21', datetime('now'), datetime('now')),
('PCI_DSS', 'Payment Card Industry Data Security Standard', '4.0', 'Payment card data protection', 'PCI Security Standards Council', 'Payment Processing', TRUE, '2022-03-31', datetime('now'), datetime('now'));

-- Insert sample governance structures
INSERT INTO governance_structures VALUES 
('GOV_001', 'Board of Directors', 'Executive', 'Ultimate oversight and governance authority', 'Board Chair', 'Quarterly', 9, '2024-01-15', '2024-04-15', 'ACTIVE', datetime('now')),
('GOV_002', 'Risk Committee', 'Committee', 'Board-level risk oversight committee', 'Risk Committee Chair', 'Monthly', 8, '2024-01-10', '2024-02-10', 'ACTIVE', datetime('now')),
('GOV_003', 'Audit Committee', 'Committee', 'Independent audit oversight', 'Audit Committee Chair', 'Quarterly', 9, '2024-01-05', '2024-04-05', 'ACTIVE', datetime('now')),
('GOV_004', 'Executive Leadership Team', 'Executive', 'Senior management oversight', 'CEO', 'Weekly', 8, '2024-01-20', '2024-02-20', 'ACTIVE', datetime('now')),
('GOV_005', 'IT Steering Committee', 'Committee', 'Technology governance and oversight', 'CIO', 'Monthly', 7, '2024-01-12', '2024-02-12', 'ACTIVE', datetime('now')),
('GOV_006', 'Data Governance Council', 'Council', 'Data management and privacy oversight', 'CDO', 'Monthly', 8, '2024-01-08', '2024-02-08', 'ACTIVE', datetime('now')),
('GOV_007', 'Security Steering Committee', 'Committee', 'Information security governance', 'CISO', 'Bi-weekly', 9, '2024-01-18', '2024-02-01', 'ACTIVE', datetime('now')),
('GOV_008', 'Compliance Committee', 'Committee', 'Regulatory compliance oversight', 'Chief Compliance Officer', 'Monthly', 8, '2024-01-15', '2024-02-15', 'ACTIVE', datetime('now'));

-- Insert sample policies
INSERT INTO policies VALUES 
('POL_001', 'Information Security Policy', 'Security', 'Information Security', 'Comprehensive information security policy covering all aspects of data protection', 'CISO', '2024-01-01', '2024-01-01', '2025-01-01', 'ACTIVE', '/policies/security/info_sec_policy.pdf', datetime('now'), datetime('now')),
('POL_002', 'Data Privacy Policy', 'Privacy', 'Data Protection', 'Data privacy and protection policy compliant with GDPR and other regulations', 'DPO', '2024-01-01', '2024-01-01', '2025-01-01', 'ACTIVE', '/policies/privacy/data_privacy_policy.pdf', datetime('now'), datetime('now')),
('POL_003', 'Access Control Policy', 'Security', 'Access Management', 'User access control and management policy', 'IT Security Manager', '2024-01-01', '2024-01-01', '2025-01-01', 'ACTIVE', '/policies/security/access_control_policy.pdf', datetime('now'), datetime('now')),
('POL_004', 'Risk Management Policy', 'Risk', 'Risk Management', 'Enterprise risk management policy and procedures', 'CRO', '2024-01-01', '2024-01-01', '2025-01-01', 'ACTIVE', '/policies/risk/risk_management_policy.pdf', datetime('now'), datetime('now')),
('POL_005', 'Business Continuity Policy', 'Operational', 'Business Continuity', 'Business continuity and disaster recovery policy', 'COO', '2024-01-01', '2024-01-01', '2025-01-01', 'ACTIVE', '/policies/operational/business_continuity_policy.pdf', datetime('now'), datetime('now')),
('POL_006', 'Vendor Management Policy', 'Operational', 'Third Party Risk', 'Third-party vendor risk management policy', 'Procurement Manager', '2024-01-01', '2024-01-01', '2025-01-01', 'ACTIVE', '/policies/operational/vendor_management_policy.pdf', datetime('now'), datetime('now')),
('POL_007', 'Incident Response Policy', 'Security', 'Incident Management', 'Security incident response and management policy', 'CISO', '2024-01-01', '2024-01-01', '2025-01-01', 'ACTIVE', '/policies/security/incident_response_policy.pdf', datetime('now'), datetime('now')),
('POL_008', 'Code of Conduct', 'Ethics', 'Corporate Governance', 'Employee code of conduct and ethics policy', 'Chief Ethics Officer', '2024-01-01', '2024-01-01', '2025-01-01', 'ACTIVE', '/policies/ethics/code_of_conduct.pdf', datetime('now'), datetime('now'));

-- Insert sample controls
INSERT INTO controls VALUES 
('CTRL_001', 'Multi-Factor Authentication', 'Technical', 'Access Control', 'Implement MFA for all privileged accounts and sensitive systems', 'IMPLEMENTED', 'IT Security Team', '2024-01-15', 'Monthly', '2024-01-15', 'PASS', 9, datetime('now'), datetime('now')),
('CTRL_002', 'Data Encryption at Rest', 'Technical', 'Data Protection', 'Encrypt sensitive data stored in databases and file systems', 'IMPLEMENTED', 'Database Team', '2024-01-10', 'Quarterly', '2024-01-10', 'PASS', 8, datetime('now'), datetime('now')),
('CTRL_003', 'Security Awareness Training', 'Administrative', 'Human Resources', 'Mandatory security awareness training for all employees', 'IMPLEMENTED', 'HR Department', '2024-01-05', 'Annually', '2024-01-05', 'PASS', 7, datetime('now'), datetime('now')),
('CTRL_004', 'Firewall Configuration', 'Technical', 'Network Security', 'Configure and maintain network firewalls according to security standards', 'IMPLEMENTED', 'Network Team', '2024-01-08', 'Monthly', '2024-01-08', 'PASS', 8, datetime('now'), datetime('now')),
('CTRL_005', 'Vulnerability Scanning', 'Technical', 'Vulnerability Management', 'Regular vulnerability scanning of all systems and applications', 'IMPLEMENTED', 'Security Team', '2024-01-12', 'Weekly', '2024-01-12', 'PASS', 9, datetime('now'), datetime('now')),
('CTRL_006', 'Backup and Recovery', 'Technical', 'Business Continuity', 'Regular backup and recovery testing procedures', 'IMPLEMENTED', 'IT Operations', '2024-01-20', 'Monthly', '2024-01-20', 'PASS', 8, datetime('now'), datetime('now')),
('CTRL_007', 'Change Management', 'Administrative', 'Change Control', 'Formal change management process for all IT changes', 'IMPLEMENTED', 'Change Advisory Board', '2024-01-18', 'Continuous', '2024-01-18', 'PASS', 7, datetime('now'), datetime('now')),
('CTRL_008', 'Audit Logging', 'Technical', 'Monitoring', 'Comprehensive audit logging for all critical systems', 'IMPLEMENTED', 'Security Operations', '2024-01-25', 'Daily', '2024-01-25', 'PASS', 9, datetime('now'), datetime('now')),
('CTRL_009', 'Physical Security', 'Physical', 'Physical Access', 'Physical security controls for data centers and offices', 'IMPLEMENTED', 'Facilities Team', '2024-01-22', 'Monthly', '2024-01-22', 'PASS', 8, datetime('now'), datetime('now')),
('CTRL_010', 'Data Classification', 'Administrative', 'Data Management', 'Data classification and handling procedures', 'PARTIALLY_IMPLEMENTED', 'Data Governance Team', '2024-01-30', 'Quarterly', '2024-01-30', 'PARTIAL', 6, datetime('now'), datetime('now'));

-- Insert sample framework mappings
INSERT INTO framework_mappings VALUES 
('MAP_001', 'NIST_CSF', 'ISO27001', 'ID.AM-1', 'A.8.1.1', 'DIRECT', 'HIGH', 'Asset inventory mapping between frameworks', datetime('now')),
('MAP_002', 'NIST_CSF', 'ISO27001', 'PR.AC-1', 'A.9.1.1', 'DIRECT', 'HIGH', 'Access control policy mapping', datetime('now')),
('MAP_003', 'NIST_CSF', 'COBIT', 'ID.GV-1', 'EDM03.01', 'DIRECT', 'MEDIUM', 'Governance structure mapping', datetime('now')),
('MAP_004', 'ISO27001', 'COBIT', 'A.5.1.1', 'APO01.01', 'PARTIAL', 'MEDIUM', 'Information security policy mapping', datetime('now')),
('MAP_005', 'NIST_CSF', 'PCI_DSS', 'PR.DS-1', '3.4', 'DIRECT', 'HIGH', 'Data protection mapping', datetime('now')),
('MAP_006', 'ISO27001', 'GDPR', 'A.18.1.4', 'Art. 25', 'PARTIAL', 'MEDIUM', 'Privacy by design mapping', datetime('now')),
('MAP_007', 'COBIT', 'COSO', 'APO12.01', 'Control Environment', 'CONCEPTUAL', 'LOW', 'Risk management mapping', datetime('now')),
('MAP_008', 'NIST_CSF', 'SOX', 'DE.CM-1', 'ITGC-1', 'PARTIAL', 'MEDIUM', 'Monitoring controls mapping', datetime('now'));

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_frameworks_sector ON grc_frameworks(industry_sector);
CREATE INDEX IF NOT EXISTS idx_policies_type ON policies(policy_type);
CREATE INDEX IF NOT EXISTS idx_controls_status ON controls(implementation_status);
CREATE INDEX IF NOT EXISTS idx_governance_type ON governance_structures(structure_type);
CREATE INDEX IF NOT EXISTS idx_mappings_source ON framework_mappings(source_framework);
CREATE INDEX IF NOT EXISTS idx_mappings_target ON framework_mappings(target_framework);

-- Create views for common queries
CREATE VIEW IF NOT EXISTS active_policies AS
SELECT * FROM policies WHERE status = 'ACTIVE';

CREATE VIEW IF NOT EXISTS implemented_controls AS
SELECT * FROM controls WHERE implementation_status = 'IMPLEMENTED';

CREATE VIEW IF NOT EXISTS mandatory_frameworks AS
SELECT * FROM grc_frameworks WHERE mandatory = TRUE;

CREATE VIEW IF NOT EXISTS framework_control_summary AS
SELECT 
    gf.framework_name,
    COUNT(c.control_id) as total_controls,
    AVG(c.effectiveness_rating) as avg_effectiveness
FROM grc_frameworks gf
LEFT JOIN controls c ON gf.framework_id = c.control_family
GROUP BY gf.framework_id, gf.framework_name;

