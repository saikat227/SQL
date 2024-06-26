/*Data cleaning */

select * 
from portfolioproject.nashvillehousing n ;


-------------------------------------------------------------------------------------------------------
-- Standardize date format

select SaleDateConvertad, convert(Date, SaleDate)
from portfolioproject.nashvillehousing n 
update nashvillehousing 
set SaleDate = convert(Date, SaleDate)

alter table nashvillehousing 
add SaleDateConvertad date;
update nashvillehousing 
set SaleDateConvertad = convert(Date, SaleDate)
;

----------------------------------------------------
-- Populate Property address

select PropertyAddress 
from portfolioproject.nashvillehousing n;

select n.ParcelID, n.PropertyAddress, n2.ParcelID , n2.PropertyAddress, ifnull(n.PropertyAddress, n2.PropertyAddress) 
from portfolioproject.nashvillehousing n
join portfolioproject.nashvillehousing n2 
on n.ParcelID = n2.ParcelID 
and n.UniqueID <> n2.UniqueID 
where PropertyAddress is null 

update n 
set PropertyAddress = ifnull(n.PropertyAddress, n2.PropertyAddress) 
from portfolioproject.nashvillehousing n
join portfolioproject.nashvillehousing n2 
on n.ParcelID = n2.ParcelID 
and n.UniqueID <> n2.UniqueID 
where PropertyAddress is null 
;

 ----------------------------------------------------------------------------------------------
 -- Breaking out address into individual columns(Assress, City, State)
 
 select PropertyAddress
 from portfolioproject.nashvillehousing n;

 select substring_index(PropertyAddress, ',', 1),
 substring_index(PropertyAddress, ',', -1)
 from portfolioproject.nashvillehousing n 
 
alter table nashvillehousing 
 add PropertySplitAddress varchar(255);
update nashvillehousing
  set PropertySplitAddress = substring_index(PropertyAddress, ',', 1)
 
alter table nashvillehousing 
 add PropertySplitCity varchar(255);
update nashvillehousing
  set PropertySplitCity = substring_index(PropertyAddress, ',', -1)
;
  
------------------------------------------------------------------------------------------------------------------------------
-- Change Y and N to Yes and no "Sold as Vacant" field

select distinct(SoldAsVacant), count(SoldAsVacant)
from portfolioproject.nashvillehousing n 
group by SoldAsVacant 
order by 2
 
select SoldAsVacant
, case when SoldAsVacant = 'Y' then 'Yes'
	   when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end
from portfolioproject.nashvillehousing n 

	   
 update nashvillehousing
 set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	   when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end
 ;
 
------------------------------------------------------------------------------------------------------------
-- Remove duplicates
select *
from portfolioproject.nashvillehousing n ;

with RowNumCTE as(
select *,
row_number() over(
partition by ParcelID,
			PropertyAddress,
 			SalePrice,
 			SaleDate,
 			LegalReference
 order by UniqueID			
) as Row_num
from portfolioproject.nashvillehousing n 
)
select *
from RowNumCTE
where Row_num > 1
order by PropertyAddress
/*
If you want to delete duplicate row
delete
from RowNumCTE
where Row_num > 1
*/
;

--------------------------------------------------------------------------------------------------------------------
-- Delete unused columns 

select *
from portfolioproject.nashvillehousing n ;

alter table portfolioproject.nashvillehousing 
drop column PropertyAddress, TaxDistrict

alter table portfolioproject.nashvillehousing  
drop column SaleDate

;





 
 
 
 
