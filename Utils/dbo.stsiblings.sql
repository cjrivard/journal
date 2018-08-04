drop function STSiblings
GO

CREATE FUNCTION [dbo].[STSiblings]
(
    @p_SysTypeId INT
)
RETURNS TABLE
AS
    RETURN
    SELECT  st.SysTypeCatId
            , dbo.STCategory(st.Id) AS SysTypeCat
            , st.Id AS SysTypeId
            , RTRIM(st.ShortDescr) ShortDescr
            , RTRIM(st.descr) Descr
            , st.DisplayOrder
        FROM  SysType st
        WHERE  st.SysTypeCatId = (SELECT MAX(SysTypeCatId) FROM SysType WHERE Id = @p_SysTypeId)
            AND st.EffStatus = 'A' 
            AND st.BegEffDate = (SELECT MAX(sub.BegEffDate) FROM SysType sub WHERE sub.Id = st.Id)

GO