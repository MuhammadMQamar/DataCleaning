CREATE TABLE datacleaning (UniqueID INT,
    ParcelID VARCHAR(50),
    LandUse VARCHAR(50),
    PropertyAddress VARCHAR(100),
    SaleDate DATE,
    SalePrice INT,
    LegalReference VARCHAR(50),
    SoldAsVacant VARCHAR(10),
    OwnerName VARCHAR(100),
    OwnerAddress VARCHAR(100),
    Acreage DECIMAL(5,2),
    TaxDistrict VARCHAR(50),
    LandValue INT,
    BuildingValue INT,
    TotalValue INT,
    YearBuilt INT,
    Bedrooms INT,
    FullBath INT,
    HalfBath INT)
	
ALTER TABLE datacleaning
ALTER COLUMN SalePrice TYPE character varying(100);

SELECT * FROM datacleaning;


-- Data cleaning 

-- Standardize Date Format
SELECT "saledate", CAST("saledate" AS DATE)
FROM "datacleaning";

UPDATE "datacleaning"
SET "saledate" = CAST("saledate" AS DATE);

ALTER TABLE "datacleaning"
ADD COLUMN "SaleDateConverted" DATE;

UPDATE "datacleaning"
SET "SaleDateConverted" = CAST("saledate" AS DATE);

SELECT "SaleDateConverted"
FROM "datacleaning";

-- Populate Property Address data
SELECT a."parcelid", a."propertyaddress", b."parcelid", b."propertyaddress", COALESCE(a."propertyaddress",b."propertyaddress")
FROM "datacleaning" a
JOIN "datacleaning" b
	ON a."parcelid" = b."parcelid"
	AND a."uniqueid" <> b."uniqueid"
WHERE a."propertyaddress" IS NULL;

WITH b AS (
  SELECT "parcelid", "propertyaddress"
  FROM "datacleaning"
)
UPDATE "datacleaning" a
SET "propertyaddress" = COALESCE(a."propertyaddress", b."propertyaddress")
FROM b
WHERE a."parcelid" = b."parcelid"
AND a."propertyaddress" IS NULL;

-- Breaking out Address into Individual Columns (Address, City, State)
ALTER TABLE "datacleaning"
ADD COLUMN "PropertySplitAddress" VARCHAR(255);

UPDATE "datacleaning"
SET "PropertySplitAddress" = SPLIT_PART("propertyaddress", ',', 1);

ALTER TABLE "datacleaning"
ADD COLUMN "PropertySplitCity" VARCHAR(255);

UPDATE "datacleaning"
SET "PropertySplitCity" = SPLIT_PART("propertyaddress", ',', 2);

SELECT "PropertySplitCity", "PropertySplitAddress"
FROM "datacleaning";

-- Change Y and N to Yes and No in "Sold as Vacant" field
UPDATE "datacleaning"
SET "soldasvacant" = CASE 
	WHEN "soldasvacant" = 'Y' THEN 'Yes'
	WHEN "soldasvacant" = 'N' THEN 'No'
	ELSE "soldasvacant"
	END;

SELECT "soldasvacant"
FROM "datacleaning"

-- Remove Duplicates
WITH "RowNumCTE" AS (
	SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY "parcelid",
				 "propertyaddress",
				 "saleprice",
				 "saledate",
				 "legalreference"
				 ORDER BY
					"uniqueid"
					) row_num
	FROM "datacleaning"
)
SELECT *
FROM "RowNumCTE"
WHERE row_num > 1
ORDER BY "propertyaddress";

-- Delete Unused Columns
ALTER TABLE "datacleaning"
DROP COLUMN "owneraddress",
DROP COLUMN "taxdistrict",
DROP COLUMN "propertyaddress",
DROP COLUMN "saledate";

SELECT * FROM datacleaning



