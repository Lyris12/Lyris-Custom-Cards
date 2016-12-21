--created & coded by Lyris
--Fate's Illusioner
function c101010285.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--Once per turn, during either player's turn: You can send 1 "Fate's" monster you control to the Graveyard, then target 1 Pendulum card your opponent controls; Special Summon 1 "Illusioner Token" (Warrior-Type/Pendulum/LIGHT/Level 1/ATK 0/DEF 0), then place that Token in your Pendulum Zone. (When Summoned, its Pendulum Scale becomes equal to the targeted card's Pendulum Scale.)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c101010285.cost)
	e1:SetTarget(c101010285.pttg)
	e1:SetOperation(c101010285.ptop)
	c:RegisterEffect(e1)
	--During either player's turn, when a card or effect is activated: You can Special Summon this card from your Graveyard.
	
	--If this card is Special Summoned from the hand or with another "Fate's" card, except by Pendulum Summon: You take no damage for the rest of this turn, also, if you control a "Fate's" monster, except "Fate's Illusioner", gain LP equal to the amount of damage you took this turn, then you can inflict damage to your opponent equal to the amount of LP you gained.
	
end
function c101010285.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf7a) and c:IsAbleToGraveAsCost()
end
function c101010285.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010285.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101010285.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c101010285.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c101010285.pttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c101010285.filter(chkc) end
	if chk==0 then
		local seq=e:GetHandler():GetSequence()
		return not Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)
			and Duel.IsExistingTarget(c101010285.filter,tp,0,LOCATION_ONFIELD,1,nil)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
			and Duel.IsPlayerCanSpecialSummonMonster(tp,101010404,0,0x1004011,0,600,1,RACE_WARRIOR,ATTRIBUTE_LIGHT)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	Duel.SelectTarget(tp,c101010285.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c101010285.ptop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,101010404,0,0x1004011,0,600,1,RACE_WARRIOR,ATTRIBUTE_LIGHT) then return end
	local token=Duel.CreateToken(tp,101010404)
	if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.BreakEffect()
		Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) and tc:IsFaceup() then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CHANGE_LSCALE)
			e2:SetValue(tc:GetLeftScale())
			e2:SetReset(RESET_EVENT+0x1fe0000)
			token:RegisterEffect(e2,true)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_CHANGE_RSCALE)
			e3:SetValue(tc:GetRightScale())
			token:RegisterEffect(e3,true)
		end
		--If you control a Pendulum Summoned monster, destroy all "Illusioner Tokens" on the field.
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_SELF_DESTROY)
		e4:SetRange(LOCATION_PZONE)
		e4:SetCondition(c101010285.descon)
		e4:SetReset(RESET_EVENT+0x1fe0000)
		token:RegisterEffect(e4)
	end
end
function c101010285.sdfilter(c)
	return c:IsFaceup() and bit.band(c:GetSummonType(),SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c101010285.descon(e)
	return Duel.IsExistingMatchingCard(c101010285.sdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
