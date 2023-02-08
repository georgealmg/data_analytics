create database if not exists ciscodevices;
use ciscodevices;
drop table if exists devices;
drop table if exists products;
drop table if exists software;
drop table if exists eox;

---------------------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS devices (
    Hostname VARCHAR(30) NOT NULL,
    ProductID VARCHAR(30) NOT NULL,
    SerialNumber VARCHAR(15) NOT NULL,
    OS VARCHAR(5) NOT NULL,
    OSVersion VARCHAR(30) NOT NULL,
    PRIMARY KEY (SerialNumber)
);

CREATE TABLE IF NOT EXISTS products (
    ProductID VARCHAR(30) NOT NULL,
    ProductSeries VARCHAR(50) NOT NULL,
    ProductName VARCHAR(50) NOT NULL,
    ProductType VARCHAR(15) NOT NULL,
    ReleaseDate DATE NOT NULL,
    PRIMARY KEY (ProductID)
);

CREATE TABLE IF NOT EXISTS software (
    ProductID VARCHAR(30) NOT NULL,
    RecommendedOSVersion VARCHAR(15) NULL,
    ReleaseDate DATE NULL,
    ImageName VARCHAR(50) NULL,
    ImageSize INT NULL,
    PRIMARY KEY (ProductID)
);

CREATE TABLE IF NOT EXISTS eox (
    SerialNumber VARCHAR(15) NOT NULL,
    ProductID VARCHAR(30) NOT NULL,
    Customer VARCHAR(20) NOT NULL,
    CustomerCountry VARCHAR(25) NOT NULL,
    EoLDate DATE NULL,
    PRIMARY KEY (SerialNumber),
    FOREIGN KEY (SerialNumber)
        REFERENCES devices (SerialNumber)
);

---------------------------------------------------------------------------------------------

insert into devices(Hostname,ProductID,SerialNumber,OS,OSVersion) values
('LO_C95K_CORE01','C9500-24Y4C','FDO24340K3X','iosxe','17.6.3'),
('NY_C93K_DST01','C9300L-48P-4G','FJC243811T3','iosxe','17.6.2'),
('BA_C38K_DST01','WS-C3850-12S','FOC2152U0GS','iosxe','16.12.3a'),
('RO_C29K_DST01','WS-C2960G-24TC-L','FOC1203X2FK','ios','12.2(50)SE3'),
('MA_C37K_DST01','WS-C3750X-48T-S','FDO1733Z1XD','ios','15.2(4)E8'),
('SA_N9K_DST01','N9K-C93180YC-FX','FDO24290992','nxos','9.3(5)'),
('INT_C29K_RO01','CISCO2901/K9','FTX173881WL','ios','15.2(4)M4');

insert into products(ProductID,ProductSeries,ProductName,ProductType,ReleaseDate) values
('C9500-24Y4C','C9500SERIES','Cisco Catalyst C9500-24Y4C Switch','SWITCH','2018-03-31'),
('C9300L-48P-4G','C9300SERIES','Cisco Catalyst 9300L Switch Stack','SWITCH','2019-06-02'),
('WS-C3850-12S','3K AGG FIBER','Cisco Catalyst 3850-12S-E Switch','SWITCH','2014-05-20'),
('WS-C2960G-24TC-L','C2960 SERIES','Cisco Catalyst 2960G-24TC-L Switch','SWITCH','2005-09-18'),
('WS-C3750X-48T-S','SYSTEM','Cisco Catalyst 3750X-48T-S Switch','MULTIPROD','2010-03-15'),
('N9K-C93180YC-FX','N9300 SERIES','Cisco Nexus 93180YC-FX Switch','SWITCH','2017-03-22'),
('CISCO2901/K9','2901 SERIES','Cisco 2901 Integrated Services Router','ROUTER','2009-10-13');

insert into software(ProductID,RecommendedOSVersion,ReleaseDate,ImageName,ImageSize) values
('C9500-24Y4C','17.6.4','2022-08-18','cat9k_iosxe_npe.17.06.04.SPA.bin','1008737813'),
('C9300L-48P-4G','17.6.4','2022-08-18','cat9k_iosxe.17.06.04.SPA.bin','1017587860'),
('WS-C3850-12S','16.12.8','2022-09-20','cat3k_caa-universalk9ldpe.16.12.08.SPA.bin','480528610'),
('WS-C2960G-24TC-L',Null,Null,Null,Null),
('WS-C3750X-48T-S','15.2(4)E10','2020-04-07','c3750e-universalk9npe-tar.152-4.E10.tar','30720000'),
('N9K-C93180YC-FX','15.2(6e)','2022-08-30','aci-n9000-dk9.15.2.6e.bin','2136699504'),
('CISCO2901/K9','15.7(3)M8','2021-03-09','c2900-universalk9-mz.SPA.157-3.M8.bin','110493264');

insert into eox(SerialNumber,ProductID,Customer,CustomerCountry,EoLDate) values
('FDO24340K3X','C9500-24Y4C','COCA COLA COMPANY','United Kingdom',Null),
('FJC243811T3','C9300L-48P-4G','COCA COLA COMPANY','United States',Null),
('FOC2152U0GS','WS-C3850-12S','COCA COLA COMPANY','Argentina','2021-04-30'),
('FOC1203X2FK','WS-C2960G-24TC-L','COCA COLA COMPANY','Italy','2011-08-01'),
('FDO1733Z1XD','WS-C3750X-48T-S','COCA COLA COMPANY','Spain','2015-10-31'),
('FDO24290992','N9K-C93180YC-FX','COCA COLA COMPANY','Chile',Null),
('FTX173881WL','CISCO2901-V/K9','COCA COLA COMPANY','United States','2016-09-09');

---------------------------------------------------------------------------------------------

SELECT 
    OS, COUNT(OS) AS OSCount
FROM
    devices
GROUP BY OS;

---------------------------------------------------------------------------------------------

SELECT 
    d.Hostname, d.OS, d.OSVersion, s.RecommendedOSVersion
FROM
    devices AS d
        JOIN
    software AS s ON d.ProductID = s.ProductID;

SELECT 
    d.*, p.ReleaseDate, e.EoLDate
FROM
    devices AS d
        LEFT JOIN
    products AS p ON d.ProductID = p.ProductID
        JOIN
    eox AS e ON d.SerialNumber = e.SerialNumber;

