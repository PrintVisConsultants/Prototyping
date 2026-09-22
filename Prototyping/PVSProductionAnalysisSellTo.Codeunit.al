codeunit 50101 "PVS Prod. Analysis SellTo"
{
    EventSubscriberInstance = StaticAutomatic;

    [EventSubscriber(ObjectType::Table, Database::"PrintVis Production Analysis", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertProductionAnalysis(var Rec: Record "PrintVis Production Analysis"; RunTrigger: Boolean)
    begin
        if not RunTrigger then
            exit;

        ApplySellToFields(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"PrintVis Production Analysis", 'OnBeforeModifyEvent', '', false, false)]
    local procedure OnBeforeModifyProductionAnalysis(var Rec: Record "PrintVis Production Analysis"; var xRec: Record "PrintVis Production Analysis"; RunTrigger: Boolean)
    begin
        if not RunTrigger then
            exit;

        if Rec."PrintVis Order No." = xRec."PrintVis Order No." then
            exit;

        ApplySellToFields(Rec);
    end;

    procedure ApplySellToFields(var ProductionAnalysis: Record "PrintVis Production Analysis")
    begin
        SyncSellToFields(ProductionAnalysis);
    end;

    procedure SyncSellToFields(var ProductionAnalysis: Record "PrintVis Production Analysis"): Boolean
    var
        PVSCase: Record "PVS Case";
        SellToNo: Code[20];
        SellToName: Text[100];
    begin
        if FindUniqueCaseByOrderNo(ProductionAnalysis."PrintVis Order No.", PVSCase) then begin
            SellToNo := PVSCase."Sell-To No.";
            SellToName := PVSCase."Sell-To Name";
        end;

        if (ProductionAnalysis."Sell-to No." = SellToNo) and (ProductionAnalysis."Sell-to Name" = SellToName) then
            exit(false);

        ProductionAnalysis."Sell-to No." := SellToNo;
        ProductionAnalysis."Sell-to Name" := SellToName;
        exit(true);
    end;

    local procedure FindUniqueCaseByOrderNo(PrintVisOrderNo: Code[20]; var PVSCase: Record "PVS Case"): Boolean
    var
        FirstPVSCase: Record "PVS Case";
        SellToNo: Code[20];
        SellToName: Text[100];
    begin
        if PrintVisOrderNo = '' then
            exit(false);

        PVSCase.SetCurrentKey("Order No.");
        PVSCase.SetRange("Order No.", PrintVisOrderNo);
        if not PVSCase.FindFirst() then
            exit(false);

        FirstPVSCase := PVSCase;
        SellToNo := PVSCase."Sell-To No.";
        SellToName := PVSCase."Sell-To Name";

        while PVSCase.Next() <> 0 do
            if (PVSCase."Sell-To No." <> SellToNo) or (PVSCase."Sell-To Name" <> SellToName) then
                exit(false);

        PVSCase := FirstPVSCase;
        exit(true);
    end;
}
