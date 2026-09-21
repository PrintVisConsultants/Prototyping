codeunit 50102 "PVS Prod. Analysis Install"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    begin
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
