
select *
from Nashvillehousing

--Standardize the date format

select SaleDate, convert(Date,SaleDate) 
from Nashvillehousing

Update Nashvillehousing
set SaleDate = convert(Date,SaleDate)

alter table  Nashvillehousing
add SaleDateConverted Date

Update Nashvillehousing
set SaleDateConverted = convert(Date,SaleDate)

select *
from Nashvillehousing


--Populate Property Address Data

select *
from Nashvillehousing
--where PropertyAddress is null
order by ParcelID

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, 
isnull (a.PropertyAddress,b.PropertyAddress)
from portfolioproject..Nashvillehousing a
join portfolioproject..Nashvillehousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ]<> b.[UniqueID]
where a.PropertyAddress is null


--SELECT 
--    a.ParcelID,
--    a.PropertyAddress AS Address_A,
--    b.ParcelID AS ParcelID_B,
--    b.PropertyAddress AS Address_B,
--CASE 
--        WHEN a.PropertyAddress IS NULL THEN b.PropertyAddress 
--        ELSE a.PropertyAddress 
--    END AS Merged_Address
--	from portfolioproject..Nashvillehousing a
--join portfolioproject..Nashvillehousing b
--	on a.ParcelID = b.ParcelID
--	and a.[UniqueID ]<> b.[UniqueID]
--where a.PropertyAddress is null

-Update a
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from portfolioproject..Nashvillehousing a
join portfolioproject..Nashvillehousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ]<> b.[UniqueID]
where a.PropertyAddress is null
-- Reconfirm if there area no null PropertyAddress
select *
 from portfolioproject..Nashvillehousing
 where PropertyAddress is null


--Breaking out Address into Individual columns (Address, City,State)
 
 select PropertyAddress
 from portfolioproject..Nashvillehousing

select
SUBSTRING(PropertyAddress, 1, charindex(',', PropertyAddress)-1) as Address
, Substring(PropertyAddress, charindex(',', PropertyAddress)+1, len(PropertyAddress)) as Address

from Portfolioproject..Nashvillehousing

--add 2 new columns for the address Split

alter table  Nashvillehousing
add PropertySplitAddress Nvarchar(255);

Update Nashvillehousing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, charindex(',', PropertyAddress)-1)


alter table  Nashvillehousing
add PropertySplitCity Nvarchar(255) 

update  Nashvillehousing
set propertySplitCity = Substring(PropertyAddress, charindex(',', PropertyAddress)+1, len(PropertyAddress))

--check
select *
from portfolioproject..Nashvillehousing

select OwnerAddress
from Nashvillehousing

select
PARSENAME (Replace(OwnerAddress,',','.') ,3),
PARSENAME (Replace(OwnerAddress,',','.') ,2),
PARSENAME (Replace(OwnerAddress,',','.') ,1)
from portfolioproject..Nashvillehousing

alter table Nashvillehousing
add OwnerSplitAddress Nvarchar(255)

update Nashvillehousing
set OwnerSplitAddress =PARSENAME (Replace(OwnerAddress,',','.') ,3)

alter table Nashvillehousing
add OwnerSplitCity Nvarchar(255)

update Nashvillehousing
set OwnerSplitCity =PARSENAME (Replace(OwnerAddress,',','.') ,2)

alter table Nashvillehousing
add OwnerSplitState Nvarchar(255)

update Nashvillehousing
set OwnerSplitState=PARSENAME (Replace(OwnerAddress,',','.') ,1)

select *
from portfolioproject..Nashvillehousing


---Change Y and N to Yes and No in "Sold as Vacant" field

select distinct(soldasvacant), count(SoldAsVacant)
from portfolioproject..Nashvillehousing
group by SoldAsVacant
order by 2

select SoldAsVacant, 
Case 
	when SoldAsVacant = 'Y' then 'Yes'
      when SoldAsVacant = 'N' then 'No'
	  else SoldAsVacant
 End

from portfolioproject..Nashvillehousing



Update portfolioproject..Nashvillehousing
set SoldAsVacant =
Case 
	when SoldAsVacant = 'Y' then 'Yes'
      when SoldAsVacant = 'N' then 'No'
	  else SoldAsVacant
 End
 from portfolioproject..Nashvillehousing

--Remove Duplicates
  --write a CTE

  --select distinct(uniqueID),count(uniqueID)

--  from portfolioproject..Nashvillehousing
--  group by [UniqueID ]

--write the query first then put into a cte
--To identify rows when removing duplicates, you can use rank,orderrank,row number


with RowNumCTE as (
select *,
	row_number() over(
	partition by ParcelID,
				 PropertyAddress,
				 Saleprice,
				 SaleDate,
				 LegalReference
				 order by UniqueID
				 ) row_num

from portfolioproject..Nashvillehousing
---order by ParcelID
)

--Delete

delete
from RowNumCTE
where row_num > 1

-- Delete Unused Columns

Alter Table portfolioproject..Nashvillehousing
drop column Saledate, ownerAddress, TaxDistrict, PropertyAddress

select *
from portfolioproject..Nashvillehousing





