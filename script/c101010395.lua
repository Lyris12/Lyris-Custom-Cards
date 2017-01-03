--created & coded by Lyris
function c101010395.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetTarget(c101010395.target)
    e1:SetOperation(c101010395.activate)
    c:RegisterEffect(e1)
    --If this card is in your Graveyard, except the turn it was sent there: You can banish this card from your Graveyard, then target 1 banished "Dimension-Magica" Spell Card, except a "Dimension-Magical" Normal Spell Card; add it to your hand.
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCondition(c101010395.condition)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(c101010395.thtg)
    e2:SetOperation(c101010395.thop)
    c:RegisterEffect(e2)
end
function c101010395.filter1(c,e,tp)
    local rk=c:GetRank()
    if not c.spatial then return false end
    return c:IsFaceup() and c:IsAbleToRemove()
    and Duel.IsExistingMatchingCard(c101010395.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,rk,c:GetRace(),c:GetAttribute())
end
function c101010395.filter2(c,e,tp,rk,rc,att)
    return c:GetRank()<rk and (c:IsRace(rc) or c:IsAttribute(att))
    and c:IsCanBeSpecialSummoned(e,0x4000,tp,true,false)
end
function c101010395.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c101010395.filter1(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
    and Duel.IsExistingTarget(c101010395.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,c101010395.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101010395.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local sg=Duel.SelectMatchingCard(tp,c101010395.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetRank(),tc:GetRace(),tc:GetAttribute())
    local sc=sg:GetFirst()
    if sc then
        local tg=Group.FromCards(tc)
        if tc:GetSummonType()-SUMMON_TYPE_SPECIAL==0x4000 then
            tg:Merge(tc:GetMaterial())
        end
        sc:SetMaterial(tg)
        Duel.Remove(Group.FromCards(tc),POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+0x400000)
        Duel.SpecialSummon(sc,0x4000,tp,tp,true,false,POS_FACEUP)
    end
end
function c101010395.thfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_SPELL) and c:IsSetCard(0xa03) and not (c:IsSetCard(0x1a03) and c:GetType()==TYPE_SPELL) and c:IsAbleToHand()
end
function c101010395.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c101010395.thfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c101010395.thfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,c101010395.thfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c101010395.thop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelatetoEffect(e) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,tc)
    end
end
