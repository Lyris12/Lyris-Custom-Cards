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
	--If this card declares an attack: You can target 1 other "Lavalympian" Relay monster you control; it gains 1000 ATK, but shuffle it into the Deck at the end of the Battle Phase.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(c101010482.atktg)
	e3:SetOperation(c101010482.atkop)
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
function c101010482.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
end
function c101010482.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
		e2:SetOperation(c101010482.tdop)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		e2:SetCountLimit(1)
		c:RegisterEffect(e2,tp)
	end
end
function c101010482.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,101010482)
	Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
end
