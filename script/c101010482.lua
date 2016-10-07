--Lavalympian Basketball Guard
function c101010482.initial_effect(c)
    --If you have at least 2 face-up "Lavalympian" Relay Monsters in your Extra Deck, you can Special Summon this card (from your hand).
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetRange(LOCATION_HAND)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetCondition(c101010482.spcon)
    c:RegisterEffect(e1)
    --This card gains 200 ATK for each "Lavalympian" monster you control.
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(c101010482.atkval)
    c:RegisterEffect(e2)
    --If this card attacks: You can target 1 other "Lavalympian" Relay monster you control; it gains 1000 ATK, but shuffle it into the Deck at the end of the Battle Phase.
    local e3=Effect.CreateEffect(c)
    c:RegisterEffect(e3)
end
function c101010482.filter(c)
    return c:IsFaceup() and c:IsSetCard(2849)
end
function c101010482.atkval(e,c)
    return Duel.GetMatchingGroupCount(c101010482.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)*200
end
function c101010482.spfilter(c)
    return c101010482.filter(c) and c.relay
end
function c101010482.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c101010482.spfilter,tp,LOCATION_EXTRA,0,2,nil)
end
function c101010482.atkfilter(c)
    return c101010482.filter(c) and c:IsAttackable()
end