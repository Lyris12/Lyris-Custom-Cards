--Monument Tinframe
function c101010461.initial_effect(c)
    --You can Set this card from your hand to your Spell & Trap Zone as a Trap Card.
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_MONSTER_SSET)
    e0:SetValue(TYPE_TRAP)
    c:RegisterEffect(e0)
    --If this Set card in the Spell & Trap Zone is sent to the Graveyard: Special Summon it.
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetCondition(c101010461.spcon)
    e1:SetTarget(c1010100461.sptg)
    e1:SetOperation(c101010461.spop)
    c:RegisterEffect(e1)
    --If this card is Special Summoned from the Graveyard after being sent there from the field: You can add 1 "Monument" monster from your Deck to your hand. You can only use this effect of "Monument Tinframe" once per turn.
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCountLimit(1,101010461)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e2:SetCondition(c101010461.thcon)
    e2:SetTarget(c101010461.thtg)
    e2:SetOperation(c101010461.thop)
    c:RegisterEffect(e2)
end
function c101010461.
end