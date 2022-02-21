-- Standardizing the date format
Select * from NashvilleHousing;
Select SaleDate, cast(SaleDate AS datetime ) from NashvilleHousing;
Alter table NashvilleHousing add SaleDateConverted Date;
Update NashvilleHousing set SaleDateConverted = cast(SaleDate as DATE);


-- Populate Property address data where it is null
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, IFNULL(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
    join NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.ID <> b.ID
where a.PropertyAddress is null;

create temporary table temp_table
    select a.ID as ID, IFNULL(a.PropertyAddress, b.PropertyAddress) as newP
from NashvilleHousing a
    join NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.ID <> b.ID
where a.PropertyAddress is null;

select * from temp_table;

update NashvilleHousing
join temp_table
on NashvilleHousing.ID = temp_table.ID
set NashvilleHousing.PropertyAddress = temp_table.newP
where NashvilleHousing.PropertyAddress is null;

Select * from NashvilleHousing where PropertyAddress is null;


-- Breaking out address into individual columns (Address, City, State)
-- Property Address
Select PropertyAddress from NashvilleHousing;

Select
SUBSTRING(PropertyAddress, 1, locate(',', PropertyAddress) - 1) as Address
, SUBSTRING(PropertyAddress, locate(',', PropertyAddress) + 1, LENGTH(PropertyAddress)) as Address
from NashvilleHousing;

Alter table NashvilleHousing add PropertySplitAddress nvarchar(255);
Update NashvilleHousing set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, locate(',', PropertyAddress) - 1);

Alter table NashvilleHousing add PropertySplitCity nvarchar(255);
Update NashvilleHousing set PropertySplitCity = SUBSTRING(PropertyAddress, locate(',', PropertyAddress) + 1, LENGTH(PropertyAddress));

Select * from NashvilleHousing;

-- Owner Address

Select OwnerAddress from NashvilleHousing;

Select substring_index(OwnerAddress, ',', 1),substring_index(OwnerAddress, ',', -1 ), SUBSTRING_INDEX(substring_index(OwnerAddress, ',', 2 ), ',', -1)  from NashvilleHousing;

Alter table NashvilleHousing add OwnerSplitAddress nvarchar(255);
Update NashvilleHousing set OwnerSplitAddress = substring_index(OwnerAddress, ',', 1);

Alter table NashvilleHousing add OwnerSplitCity nvarchar(255);
Update NashvilleHousing set OwnerSplitCity = SUBSTRING_INDEX(substring_index(OwnerAddress, ',', 2 ), ',', -1);

Alter table NashvilleHousing add OwnerSplitState nvarchar(255);
Update NashvilleHousing set OwnerSplitState = substring_index(OwnerAddress, ',', -1 );

Select * from NashvilleHousing;

-- Change Y and N to Yes and No in "Sold as Vacant" field

Select distinct (SoldAsVacant), count(SoldAsVacant) from NashvilleHousing group by SoldAsVacant order by SoldAsVacant;

Select SoldAsVacant,
       CASE when SoldAsVacant = 'Y' THEN 'Yes'
        when SoldAsVacant = 'N' THEN 'NO'
        else SoldAsVacant
end
from NashvilleHousing;


update NashvilleHousing
set SoldAsVacant = CASE when SoldAsVacant = 'Y' THEN 'Yes'
        when SoldAsVacant = 'N' THEN 'NO'
        else SoldAsVacant
end;

-- Remove Duplicates

delete from NashvilleHousing
where ID in (
SELECT t.ID from (
SELECT  *, ROW_NUMBER() over (
        PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
        order by ID
        ) row_num
    from NashvilleHousing) t where row_num > 1);


-- Remove Unused Columns

Select * from NashvilleHousing;

Alter table NashvilleHousing drop column PropertyAddress;

Alter table NashvilleHousing drop column OwnerAddress;






