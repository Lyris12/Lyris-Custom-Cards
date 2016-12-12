--Fate's World Judge
function c101010200.initial_effect(c)
	c:EnableReviveLimit()
	--Any card that is Tributed and sent to the Graveyard is banished instead.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e1:SetTargetRange(LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE+LOCATION_HAND)
	e1:SetTarget(function(e,c) return bit.band(c:GetReason(),REASON_RELEASE)==REASON_RELEASE end)
	e1:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e1)
	--If this card is Ritual Summoned or Special Summoned with a "Fate's" card: Your opponent cannot Special Summon Level/Rank 4 or higher monsters for the rest of this turn.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c101010200.condition)
	e3:SetOperation(c101010200.operation)
	c:RegisterEffect(e3)
end
function c101010200.mat_filter(c)
	return c:GetLevel()~=9
end
function c101010200.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetSummonType()==SUMMON_TYPE_RITUAL then return true end
	return re:GetHandler():IsSetCard(0xf7a)
end
function c101010200.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(0,1)
	e1:SetTarget(c101010200.sumlimit)
	Duel.RegisterEffect(e1,tp)
end
function c101010200.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLevelBelow(4)
end
