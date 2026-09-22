codeunit 50101 "PVS Prod. Analysis SellTo"
{
    EventSubscriberInstance = StaticAutomatic;

    var
        PreviousOrderNosByRecordId: Dictionary of [Text, Code[20]];

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

        if not OrderNoChanged(Rec, xRec) then
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

    procedure RememberOrderNoBeforeValidate(ProductionAnalysis: Record "PrintVis Production Analysis"; PreviousOrderNo: Code[20])
    begin
        if ProductionAnalysis.IsTemporary() or IsNullGuid(ProductionAnalysis.SystemId) then
            exit;

        PreviousOrderNosByRecordId.Set(GetRecordKey(ProductionAnalysis), PreviousOrderNo);
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

    local procedure OrderNoChanged(ProductionAnalysis: Record "PrintVis Production Analysis"; xProductionAnalysis: Record "PrintVis Production Analysis"): Boolean
    var
        PreviousOrderNo: Code[20];
        RecordKey: Text;
    begin
        RecordKey := GetRecordKey(ProductionAnalysis);
        if PreviousOrderNosByRecordId.Get(RecordKey, PreviousOrderNo) then begin
            PreviousOrderNosByRecordId.Remove(RecordKey);
            exit(ProductionAnalysis."PrintVis Order No." <> PreviousOrderNo);
        end;

        exit(ProductionAnalysis."PrintVis Order No." <> xProductionAnalysis."PrintVis Order No.");
    end;

    local procedure GetRecordKey(ProductionAnalysis: Record "PrintVis Production Analysis"): Text
    begin
        exit(Format(ProductionAnalysis.RecordId));
    end;
}
