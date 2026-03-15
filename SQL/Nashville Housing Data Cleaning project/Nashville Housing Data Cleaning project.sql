
-- Cleaning Data
Select *
from Portfolioproject .. NashvilleHousing

-- Standardize Date Format from datetime to date

Select saleDate, CONVERT(Date,SaleDate)
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE Portfolioproject .. NashvilleHousing
Add SaleDateConverted Date;
Update Portfolioproject .. NashvilleHousing
Set SaleDateConverted = CONVERT(Date,SaleDate)

-----------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From PortfolioProject.dbo.NashvilleHousing
-- Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from Portfolioproject .. NashvilleHousing a
join Portfolioproject .. NashvilleHousing b
on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from Portfolioproject .. NashvilleHousing a
join Portfolioproject .. NashvilleHousing b
on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

--------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City)

select PropertyAddress
from Portfolioproject .. NashvilleHousing


Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
from Portfolioproject .. NashvilleHousing

ALTER TABLE Portfolioproject .. NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update Portfolioproject .. NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE Portfolioproject .. NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update Portfolioproject .. NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

Select *
from Portfolioproject .. NashvilleHousing

----------------------------------------------------------------------------------------

 -- Breaking out  OwnerAddress into Individual Columns (Address, City, State)

Select OwnerAddress
from Portfolioproject .. NashvilleHousing

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE Portfolioproject .. NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update Portfolioproject .. NashvilleHousing
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE Portfolioproject .. NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update Portfolioproject .. NashvilleHousing
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE Portfolioproject .. NashvilleHousing
Add OwnerySplitState Nvarchar(255);

Update Portfolioproject .. NashvilleHousing
Set OwnerySplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

-------------------------------------------------------------------------------------
-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject.dbo.NashvilleHousing

Update Portfolioproject .. NashvilleHousing
SET 
SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	                When SoldAsVacant = 'N' THEN 'No'
	                ELSE SoldAsVacant
	                END
----------------------------------------------------------------------------
-- Remove Duplicates


WITH RowNumCTE as
(Select *,
	ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
	ORDER BY UniqueID) row_num

From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)

Delete 
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress

WITH RowNumCTE as
(Select *,
	ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
	ORDER BY UniqueID) row_num

From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
select * 
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


-------------------------------------------------------------------------------------
-- Delete Unused Columns

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

---------------------------------------------------------------------------------------

Select *
From PortfolioProject.dbo.NashvilleHousing
