codeunit 50103 "PVS Prod. Analysis Upgrade"
{
    Subtype = Upgrade;

    trigger OnUpgradePerCompany()
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
                ProductionAnalysis.Modify(true);
        until ProductionAnalysis.Next() = 0;
    end;
}
