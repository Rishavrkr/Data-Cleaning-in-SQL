--Cleaning Data in SQL

select *
from Portfolioproject.Nashvillehousing

--Standardizing Date Format by converting them to "Date" type

select saleDate, CONVERT(Date,saleDate) 
from Portfolioproject.Nashvillehousing

update Nashvillehousing
set saleDate = CONVERT(Date,saleDate) 

alter table Nashvillehousing
add converted_sale_date date

update Nashvillehousing
set converted_sale_date= CONVERT(Date,saleDate)

select converted_sale_date
from Portfolioproject.Nashvillehousing

select *
from Portfolioproject.Nashvillehousing

--Populating Property Address data
/*Populating the null property address with a property address that had the same ParcelID*/

select*
from Portfolioproject.Nashvillehousing
where PropertyAddress is null
order by ParcelID

select a.PropertyAddress, a.ParcelID,b.PropertyAddress,b.ParcelID
from Portfolioproject.Nashvillehousing as a
join Portfolioproject.Nashvillehousing as b
on a.ParcelID=b.ParcelID
and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

--Updating address

update a
set PropertyAddress= isnull(a.PropertyAddress,b.PropertyAddress)
from Portfolioproject.Nashvillehousing as a
join Portfolioproject.Nashvillehousing as b
on a.ParcelID=b.ParcelID
and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

--Breaking out Address into Individual Columns (Address, City, State)

select Propertyaddress
from Portfolioproject.Nashvillehousing

select Propertyaddress, SUBSTRING(Propertyaddress,1, CHARINDEX(',', Propertyaddress)-1) as address
from Portfolioproject.Nashvillehousing

select Propertyaddress, SUBSTRING(Propertyaddress,CHARINDEX(',', Propertyaddress)+1, len(Propertyaddress)+1) as address1
from Portfolioproject.Nashvillehousing 

Alter table Nashvillehousing
add newpropertyaddress nvarchar(255)

update Nashvillehousing
set newpropertyaddress= SUBSTRING(Propertyaddress,1, CHARINDEX(',', Propertyaddress)-1)

alter table Nashvillehousing
add propertyaddresscity nvarchar(255)

update Nashvillehousing
set propertyaddresscity= SUBSTRING(Propertyaddress,CHARINDEX(',', Propertyaddress)+1, len(Propertyaddress)+1)

select*
from Portfolioproject.Nashvillehousing

select OwnerAddress
from Portfolioproject.Nashvillehousing

select OwnerAddress,
parsename(replace(OwnerAddress,',','.'),3),
parsename(replace(OwnerAddress,',','.'),2),
parsename(replace(OwnerAddress,',','.'),1)
from Portfolioproject.Nashvillehousing

alter table Nashvillehousing
add newownersaddress nvarchar(255)

update Nashvillehousing
set newownersaddress= parsename(replace(OwnerAddress,',','.'),3)

alter table Nashvillehousing
add owneraddresscity nvarchar(255)

update Nashvillehousing
set owneraddresscity= parsename(replace(OwnerAddress,',','.'),2)

alter table Nashvillehousing
add owneraddressstate nvarchar(255)

update Nashvillehousing
set owneraddressstate= parsename(replace(OwnerAddress,',','.'),1)

select*
from Portfolioproject.Nashvillehousing

--Changing Y and N to Yes and No in "Sold as Vacant" field

select distinct(SoldasVacant),count(SoldasVacant)
from Portfolioproject.Nashvillehousing
group by (SoldasVacant)
order by 2

select SoldasVacant,
case when SoldasVacant= 'Y' then 'Yes'
     when SoldasVacant= 'N' then 'No'
	 else SoldasVacant
	 end
from Portfolioproject.Nashvillehousing

update Nashvillehousing
set SoldasVacant= case when SoldasVacant= 'Y' then 'Yes'
     when SoldasVacant= 'N' then 'No'
	 else SoldasVacant
	 end


--Removing Duplicates

select*,
row_number() over(
partition by PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference	
			 order by UniqueId) as row_num
from Portfolioproject.Nashvillehousing

with row_numCTE as(
select*,
row_number() over(
partition by PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference	
			 order by UniqueId) as row_num
from Portfolioproject.Nashvillehousing
)
select *
from row_numCTE
where row_num>1

with row_numCTE as(
select*,
row_number() over(
partition by PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference	
			 order by UniqueId) as row_num
from Portfolioproject.Nashvillehousing
)
delete
from row_numCTE
where row_num>1

--Deleting Unused Columns

select*
from Portfolioproject.Nashvillehousing

alter table Nashvillehousing
drop column PropertyAddress,OwnerAddress