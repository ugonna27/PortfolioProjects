With customerCTE as 
(
Select FullName, City,  ROW_NUMBER() OVER (PARTITION BY FullName, City ORDER BY FullName, City) as Duplicate_count from mydb1.dbo.Customersales
)
Delete from customerCTE where Duplicate_count>1

Select * from mydb1.dbo.Customersales
--Select sum(quantity)
,Item
from mydb1.dbo.Customersales
where item = 'cashews'
group by Item
Order by 2 asc  
  
Select 
Item
,Quantity
,FullName
from mydb1.dbo.Customersales
where FullName like '%Bridgette%'
group by Item
,Quantity
,FullName
Order by 2 asc

Select sum(quantity)
--,Item
from mydb1.dbo.Customersales 
group by Item
Order by 2 asc

Select FullName 
from mydb1.dbo.Customersales
Group by FullName
Having count (FullName)>1

Select * from mydb1.dbo.Customersales
where item = 'Peas'

Select count (1) from mydb1.dbo.Customersales

Select ROW_NUMBER() over () as num_row,
from mydb1.dbo.Customersales 
 
Select count (*) as Total from mydb1.dbo.customersales
--Find second highest UnitSales

Select Max (UnitSales) from mydb1.dbo.customersales where UnitSales <
(Select Max (UnitSales) from mydb1.dbo.Customersales)  

Select max (UnitSales) from mydb1.dbo.Customersales
Union
Select min (UnitSales) from mydb1.dbo.Customersales