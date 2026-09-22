codeunit 50102 "PVS Prod. Analysis Install"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    var
        AppInfo: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(AppInfo);
        if AppInfo.DataVersion() <> Version.Create('0.0.0.0') then
            exit;

        BackfillSellToFields();
    end;

    local procedure BackfillSellToFields()
    var
        ProductionAnalysis: Record "PrintVis Production Analysis";
        ProductionAnalysisSellTo: Codeunit "PVS Prod. Analysis SellTo";
    begin
        if not ProductionAnalysis.FindSet() then
            exit;

        repeat
            if ProductionAnalysisSellTo.SyncSellToFields(ProductionAnalysis) then
                ProductionAnalysis.Modify(false);
        until ProductionAnalysis.Next() = 0;
    end;
}
