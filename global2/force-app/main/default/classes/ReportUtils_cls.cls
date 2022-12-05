/**
********************************************************************************************************
* @company         Avanxo Colombia
* @author          Antonio Torres href=<atorres@avanxo.com>
* @proyect         Global Seguros
* @name            ReportUtils_cls 
* @description     Reports Utility class
* @dependencies    None
* @changes (Version)
* --------   ---   ----------   ---------------------------   ------------------------------------------
*            No.   Date         Author                        Description
* --------   ---   ----------   ---------------------------   ------------------------------------------
* @version   1.0   2016-08-26   Antonio Torres (AT)           Creation of the class.
********************************************************************************************************
**/

public with sharing class ReportUtils_cls {
    /**
    * @method      getRecordCountOnReport
    * @description Returns the record count of the specified report.
    * @author      Antonio Torres - 2016-06-21
    */
    public static Integer getRecordCountOnReport(Id idReportId) {
        Reports.ReportResults results = Reports.ReportManager.runReport(idReportId, Reports.ReportManager.describeReport(idReportId).getReportMetadata(), true);
        return getRecordCountOnReportResults(results);
    }

    /**
    * @method      getRecordCountOnReportResults
    * @description Returns the record count of the specified report results.
    * @author      Antonio Torres - 2016-06-21
    */
    public static Integer getRecordCountOnReportResults(Reports.ReportResults results) {
        if(results.getReportMetadata().getReportFormat() == Reports.ReportFormat.TABULAR) {
            System.debug('\n\n-=#=-\n' + 'Rows Tabular' + ': ' + ((Reports.ReportFactWithDetails)results.getFactMap().get('T!T')).getRows() + '\n-=#=-\n');
            return ((Reports.ReportFactWithDetails)results.getFactMap().get('T!T')).getRows().size();
        } else if(results.getReportMetadata().getReportFormat() == Reports.ReportFormat.SUMMARY) {
            return getRecordCountRecursivelyOnReportSummaryFactMap(results.getFactMap(), results.getGroupingsDown().getGroupings());
        } else {
            return 0;
        }
    }

    /**
    * @method      getRecordCountRecursivelyOnReportSummaryFactMap
    * @description Returns the record count on summary reports, iterating recursively over report groups.
    * @author      Antonio Torres - 2016-06-21
    */
    public static Integer getRecordCountRecursivelyOnReportSummaryFactMap(Map<String, Reports.ReportFact> mapFactMap, List<Reports.GroupingValue> lstGroupingValues) {
        Integer intRecordCount = 0;

        for(Reports.GroupingValue objGroupingValue : lstGroupingValues) {
            if(objGroupingValue.getGroupings().size() > 0) {
                intRecordCount += getRecordCountRecursivelyOnReportSummaryFactMap(mapFactMap, objGroupingValue.getGroupings());
            } else {
                System.debug('\n\n-=#=-\n' + 'Rows Summary' + ': ' + ((Reports.ReportFactWithDetails)mapFactMap.get(objGroupingValue.getKey() + '!T')).getRows() + '\n-=#=-\n');
                intRecordCount += ((Reports.ReportFactWithDetails)mapFactMap.get(objGroupingValue.getKey() + '!T')).getRows().size();
            }
        }

        return intRecordCount;
    }

    /**
    * @method       getColumnNameIndexOnReportResults
    * @description  Returns the column name index of the specified column name, on the specified report results.
    *               When the column name cannot be found, returns -1.
    * @author       Antonio Torres - 2016-06-23
    */
    public static Integer getColumnNameIndexOnReportResults(Reports.ReportResults objReportResults, String strColumnName) {
        return getColumnNameIndexOnReportResults(objReportResults, strColumnName, false);
    }
    
    public static Integer getColumnNameIndexOnReportResults(Reports.ReportResults objReportResults, String strColumnName, Boolean blnFindByLabel) {
        Integer intColumnIndexIterator  = -1;
        Integer intColumnFoundIndex     = -1;
        Map<String, Reports.DetailColumn> mapColumns = objReportResults.getReportExtendedMetadata().getDetailColumnInfo();
        //System.debug('\n\n-=#=-\n' + 'mapColumns' + ': ' + mapColumns + '\n-=#=-\n');

        for(Reports.DetailColumn objDetailColumn : mapColumns.values()) {
            intColumnIndexIterator += 1;
            //System.debug('\n\n-=#=-\n' + 'objDetailColumn.getName()' + ': ' + objDetailColumn.getName() + '\n-=#=-\n');
            //System.debug('\n\n-=#=-\n' + 'objDetailColumn.getLabel()' + ': ' + objDetailColumn.getLabel() + '\n-=#=-\n');
            
            if((blnFindByLabel ? objDetailColumn.getLabel() : objDetailColumn.getName()) == strColumnName) {
                System.debug('\n\n-=#=-\n' + 'Column Name "' + strColumnName + '" found on position: ' + intColumnIndexIterator + '\n-=#=-\n');
                intColumnFoundIndex = intColumnIndexIterator;
                break;
            }
        }

        if(intColumnFoundIndex == -1) {
            System.debug('\n\n-=#=-\n' + 'Column Name "' + strColumnName + '" NOT FOUND while searching by ' + (blnFindByLabel ? 'Label' : 'Api Name') + '\n-=#=-\n');
        }

        return intColumnFoundIndex;
    }

    /**
    * @method       getColumnNamesOfTypeOnReport
    * @description  Returns a list of SelectOption with the column names on a specified report, that are from a specified column type.
    * @author       Antonio Torres - 2016-06-24
    */
    public static List<SelectOption> getColumnNamesOfTypeOnReport(Id idReportId, Reports.ColumnDataType enmColumnType) {
        List<SelectOption> lstColumNames = new List<SelectOption>();
        
        if(idReportId != null) {
            Map<String, Reports.DetailColumn> mapColumns = Reports.ReportManager.describeReport(idReportId).getReportExtendedMetadata().getDetailColumnInfo();

            for(Reports.DetailColumn objDetailColumn : mapColumns.values()) {
                if(objDetailColumn.getDataType() == enmColumnType) {
                    System.debug('\n\n-=#=-\n' + 'Column "' + objDetailColumn.getLabel() + '" (' + objDetailColumn.getName() + ') found of type: ' + enmColumnType + '\n-=#=-\n');
                    lstColumNames.add(new SelectOption(objDetailColumn.getName(), objDetailColumn.getLabel()));
                }
            }
        }

        return lstColumNames;
    }
}