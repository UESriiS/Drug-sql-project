DROP TABLE IF EXISTS "Drug" ;
DROP TABLE IF EXISTS "Store";
DROP TABLE IF EXISTS "Customer";
DROP TABLE IF EXISTS "Employee";
DROP TABLE IF EXISTS "Organization";
DROP TABLE IF EXISTS "Sale Record";
DROP TABLE IF EXISTS "Drug Factory";
DROP TABLE IF EXISTS "Factory Driver EMPLOYEE";
DROP TABLE IF EXISTS "Shipment";
DROP TABLE IF EXISTS "Truck";
DROP TABLE IF EXISTS "raw_data";
DROP TABLE IF EXISTS "Ship_raw";


CREATE TABLE "raw_data" (
	"FID" Integer,
	"Store_ID" Integer,
	"Name" Text,
	"Telephone" Text,
	"ADDRESS" Text,
	"ZIP" Text,
	"GEOLINKID" Text,
	"Website" Text,
	"ORGAN_NAME" text
);

SELECT * FROM "raw_data";

CREATE TABLE "Ship_raw" (
	"FID" Integer,
	"Shipment_ID" bigint,
	"Factory_ID" bigint,
	"Factory_Name" Text,
	"Truck_Name" Text,
	"Truck_Model" Text,
	"Truck_License" Text,
	"Truck_Load" Text,
	"Driver_EID" bigint,
	"Driver_SSN" bigint,
	"Driver_FName" varchar(90),
	"Driver_LName" varchar(90),
	"Driver_Phone" Text,
	"Drug_ID" Integer,
	"Drug_Qty" Integer,
	"Shipment_Date" text
);

SELECT * FROM "Ship_raw";

CREATE TABLE "Organization" (
  "FID" Integer,
  "Name" Text,
  "Website" Text,
  PRIMARY KEY ("FID")
);


INSERT INTO "Organization"("FID","Name","Website")
SELECT DISTINCT "FID", "ORGAN_NAME", "Website" FROM "raw_data";

SELECT * FROM "Organization";



CREATE TABLE "Store" (
  "Store_ID" Integer,
  "FID" Integer,
  "Bname" varchar(90),
  "Telephone" text,
  "Address" text,
  "ZIP" text,
  "GeolinkID" text,
  PRIMARY KEY ("Store_ID"),
  CONSTRAINT "FK_Store.FID"
    FOREIGN KEY ("FID")
      REFERENCES "Organization"("FID")
);

INSERT INTO "Store"("Store_ID","FID","Bname","Telephone","Address","ZIP","GeolinkID")
SELECT DISTINCT "Store_ID","FID","Name","Telephone","ADDRESS","ZIP","GEOLINKID" FROM "raw_data";

SELECT * FROM "Store";






CREATE TABLE "Employee" (
  "EID" Integer,
  "SSN" Integer,
  "Store_ID" Integer,
  "EFname" varchar(90),
  "ELname" varchar(90),
  "Phone" Text,
  "Address" Text,
  PRIMARY KEY ("EID"),
  CONSTRAINT "FK_Employee.Store_ID"
    FOREIGN KEY ("Store_ID")
      REFERENCES "Store"("Store_ID")
);

SELECT * FROM "Employee";



CREATE TABLE "Customer" (
  "CID" Integer,
  "Store_ID" Integer,
  "Fname" varchar(90),
  "Lname" varchar(90),
  "Address" Text,
  "Phone" Text,
  PRIMARY KEY ("CID"),
  CONSTRAINT "FK_Customer.Store_ID"
    FOREIGN KEY ("Store_ID")
      REFERENCES "Store"("Store_ID")
);

SELECT * FROM "Customer";


CREATE TABLE "Drug Factory" (
  "Factory_ID" bigint,
  "BrandName" Text,
  PRIMARY KEY ("Factory_ID")
);

INSERT INTO "Drug Factory"("Factory_ID", "BrandName")
SELECT DISTINCT "Factory_ID", "Factory_Name" FROM "Ship_raw";

SELECT * FROM "Drug Factory";


CREATE TABLE "Drug" (
  "DID" Integer,
  "Factory_ID" bigint,
  "Qty" Integer,
  "Expiry" Text,
  "Price" Decimal,
  PRIMARY KEY ("DID"),
  CONSTRAINT "FK_Drug.Factory_ID"
    FOREIGN KEY ("Factory_ID")
      REFERENCES "Drug Factory"("Factory_ID")
);




CREATE TABLE "Sale Record" (
  "SID" Integer,
  "Store_ID" Integer,
  "CID" Integer,
  "DID" Integer,
  "Date" Text,
  PRIMARY KEY ("SID"),
  CONSTRAINT "FK_Sale Record.Store_ID"
    FOREIGN KEY ("Store_ID")
      REFERENCES "Store"("Store_ID"),
  CONSTRAINT "FK_Sale Record.DID"
    FOREIGN KEY ("DID")
      REFERENCES "Drug"("DID"),
  CONSTRAINT "FK_Sale Record.CID"
    FOREIGN KEY ("CID")
      REFERENCES "Customer"("CID")
);



CREATE TABLE "Factory Driver EMPLOYEE" (
  "EID" bigint,
  "SSN" bigint,
  "Factory_ID" bigint,	
  "FName" varchar(90),
  "LName" varchar(90),
  "Phone" Text,
  PRIMARY KEY ("EID"),
  CONSTRAINT "FK_Factory Driver EMPLOYEE.Factory_ID"
    FOREIGN KEY ("Factory_ID")
      REFERENCES "Drug Factory"("Factory_ID")
);

INSERT INTO "Factory Driver EMPLOYEE"("EID", "SSN", "Factory_ID", "FName", "LName", "Phone") 
SELECT DISTINCT "Driver_EID", "Driver_SSN", "Factory_ID", "Driver_FName", "Driver_LName", "Driver_Phone" FROM "Ship_raw";

SELECT * FROM "Factory Driver EMPLOYEE";




CREATE TABLE "Truck" (
  "TruckNum" Text,
  "Factory_ID" bigint,
  "EID" bigint,
  "TruckModel" Text,
  "TruckLoad" Text,
  "LicensePlate" Text,
  PRIMARY KEY ("TruckNum"),
  CONSTRAINT "FK_Truck.EID"
    FOREIGN KEY ("EID")
      REFERENCES "Factory Driver EMPLOYEE"("EID"),
  CONSTRAINT "FK_Truck.Factory_ID"
    FOREIGN KEY ("Factory_ID")
      REFERENCES "Drug Factory"("Factory_ID")
);

INSERT INTO "Truck"("TruckNum", "Factory_ID", "EID", "TruckModel", "TruckLoad", "LicensePlate") 
SELECT DISTINCT "Truck_Name", "Factory_ID", "Driver_EID", "Truck_Model", "Truck_Load", "Truck_License" FROM "Ship_raw";

SELECT * FROM "Truck";


CREATE TABLE "Shipment" (
  "Ship_ID" bigint,
  "TruckNum" Text,
  "FID" Integer,
  "Factory_ID" bigint,
  "DID" Integer,
  "ShipmentDate" text,
  "DrugQty" Integer,
  PRIMARY KEY ("Ship_ID"),
  CONSTRAINT "FK_Shipment.FID"
    FOREIGN KEY ("FID")
      REFERENCES "Organization"("FID"),
  CONSTRAINT "FK_Shipment.TruckNum"
    FOREIGN KEY ("TruckNum")
      REFERENCES "Truck"("TruckNum"),
  CONSTRAINT "FK_Shipment.Factory_ID"
    FOREIGN KEY ("Factory_ID")
      REFERENCES "Drug Factory"("Factory_ID")
);

INSERT INTO "Shipment"("Ship_ID", "TruckNum", "FID", "Factory_ID", "DID", "ShipmentDate", "DrugQty")
SELECT DISTINCT "Shipment_ID", "Truck_Name", "FID", "Factory_ID", "Drug_ID", "Shipment_Date", "Drug_Qty" FROM "Ship_raw"

SELECT * FROM "Drug";

UPDATE "Drug"
SET "Qty" = '100'
WHERE 
"DID" = 56221;

delete from "Drug" where "DID" = 32345

select "Drug"."DID", "Drug Factory"."Factory_ID","Drug"."Qty","Drug"."Expiry"
from "Drug"
inner join "Drug Factory"
on "Drug"."Factory_ID" = "Drug Factory"."Factory_ID"

update "Drug"
set "Qty" = 1000
where "DID" = 778899;

update "Drug Factory"
set "BrandName" = 'PfizerCV19'
where "Factory_ID" = 556677;

delete from "Drug" where "DID" = 778899
delete from "Drug Factory" where "Factory_ID" = 556677