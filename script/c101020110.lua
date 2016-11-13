--created by LionHeartKIng
--coded by Lyris
--Rusted Dragon MkIII
function c101020110.initial_effect(c)
	--If you control a "Rusted" monster, you can Special Summon this card (from your hand).
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c101020110.spcon)
	c:RegisterEffect(e1)
	--When this card is Special Summoned: You can make all "Rusted Dragons" you currently control become Level 5. You cannot Special Summon any monsters during the turn you activate this effect, except Zombie-Type monsters.
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101020110,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCost(c101020110.lvcost)
	e1:SetTarget(c101020110.lvtg)
	e1:SetOperation(c101020110.lvop)
	c:RegisterEffect(e1)
	--If this card is sent to the Graveyard for the Fusion Summon of a "Rusted" monster, or when this card is banished: You can add 1 "Rusted" card from your Deck to your hand, except "Rusted Dragon MkIII". You can only use this effect of "Rusted Dragon MkIII" once per turn.
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,101020110)
	e2:SetTarget(c101020110.target)
	e2:SetOperation(c101020110.operation)
	c:RegisterEffect(e2)
	local e0=e2:Clone()
	e0:SetCode(EVENT_BE_MATERIAL)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetCondition(c101020110.condition)
	c:RegisterEffect(e0)
	--This card's name is treated as "Rusted Dragon" while it is on the field or Graveyard.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CHANGE_CODE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetValue(101020108)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(101020110,ACTIVITY_SPSUMMON,c101020110.counterfilter)
end
function c101020110.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x858)
end
function c101020110.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c101020110.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c101020110.counterfilter(c)
	return c:IsRace(RACE_ZOMBIE)
end
function c101020110.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(101020110,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101020110.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c101020110.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:GetRace()~=RACE_ZOMBIE
end
function c101020110.filter(c)
	return c:IsFaceup() and c:IsCode(101020108)
end
function c101020110.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101020110.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c101020110.lvop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101020110.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(5)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c101020110.filter(c)
	return c:IsSetCard(0x858) and c:IsAbleToHand() and c:GetCode()~=101020110
end
function c101020110.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101020110.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101020110.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101020110.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101020110.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and r==REASON_FUSION and c:GetReasonCard():IsSetCard(0x858)
end
