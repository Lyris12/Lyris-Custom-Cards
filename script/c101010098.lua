--created & coded by Lyris
--Fate's Doomed Monger
function c101010098.initial_effect(c)
    --If this card is Normal or Special Summoned from the hand or with a "Fate's" card: You can target 1 "Fate's" monster in your Graveyard; Special Summon it in Attack Position. If this card was Pendulum Summoned, you must have a "Fate's" card in your Pendulum Zone to activate this effect. You can only use this effect of "Fate's Doomed Monger" once per turn.
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,101010098)
    e2:SetCondition(c101010098.condition)
    e1:SetTarget(c101010098.target)
    e1:SetOperation(c101010098.operation)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
end
function c101010098.condition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local pc1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
    local pc2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    return (bit.band(c:GetSummonType(),SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM and (pc1:IsSetCard() or pc2:IsSetCard()) or c:GetSummonLocation()==LOCATION_HAND
end
function c101010098.filter(c,e,tp)
    return c:IsSetCard() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101010098.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101010098.filter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZOME)>0
    and Duel.IsExistingTarget(c101010098.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local tc=Duel.SelectTarget(tp,c101010098.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,0,0)
end
function c101010098.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelatetoEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end
