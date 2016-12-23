--created & coded by Lyris
--Fate's Illusioner
function c101010285.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--Once per turn, during either player's turn: You can send 1 "Fate's" monster you control to the Graveyard, then target 1 Pendulum card your opponent controls; Special Summon 1 "Illusioner Token" (Warrior-Type/Pendulum/LIGHT/Level 1/ATK 0/DEF 0), then place that Token in your Pendulum Zone. (When Summoned, its Pendulum Scale becomes equal to the targeted card's Pendulum Scale.)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c101010285.ptcost)
	e2:SetTarget(c101010285.pttg)
	e2:SetOperation(c101010285.ptop)
	c:RegisterEffect(e2)
	--During either player's turn, when a card or effect is activated: You can Special Summon this card from your Graveyard.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetTarget(c101010285.sptg)
	e3:SetOperation(c101010285.spop)
	c:RegisterEffect(e3)
	--If this card is Special Summoned from the hand or with a "Fate's" card, except by Pendulum Summon: You take no damage for the rest of this turn, also, if you control a "Fate's" monster, except "Fate's Illusioner", gain LP equal to the amount of damage you took this turn, then you can inflict damage to your opponent equal to the amount of LP you gained.
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c101010285.condition)
	e4:SetTarget(c101010285.target)
	e4:SetOperation(c101010285.operation)
	c:RegisterEffect(e4)
	if not c101010285.global_check then
		c101010285.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(c101010285.count)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetOperation(c101010285.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
c101010285[0]=0
c101010285[1]=0
function c101010285.count(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then
		c101010285[tp]=c101010285[tp]+ev
	end
	if ep==1-tp then
		c101010285[1-tp]=c101010285[1-tp]+ev
	end
end
function c101010285.clear(e,tp,eg,ep,ev,re,r,rp)
	c101010285[0]=0
	c101010285[1]=0
end
function c101010285.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf7a) and c:IsAbleToGraveAsCost()
end
function c101010285.ptcost(e,tp,eg,ep,ev,re,r,rp,chk)
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
function c101010285.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101010285.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101010285.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if bit.band(c:GetSummonType(),SUMMON_TYPE_PEMDULUM)==SUMMON_TYPE_PEMDULUM then return false end
	return c:GetSummonLocation()==LOCATION_HAND or re:GetHandler():IsSetCard(0xf7a)
end
function c101010285.rfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf7a) and not c:IsCode(101010285)
end
function c101010285.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.IsExistingMatchingCard(c101010285.rfilter,tp,LOCATION_MZONE,0,1,nil) then
		e:SetCategory(CATEGORY_RECOVER)
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,c101010285[tp])
	end
end
function c101010285.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(0)
	Duel.RegisterEffect(e1,tp)
	if Duel.IsExistingMatchingCard(c101010285.rfilter,tp,LOCATION_MZONE,0,1,nil) then
		local dam=Duel.Recover(tp,c101010285[tp],REASON_EFFECT)
		if dam>0 and Duel.SelectYesNo(tp,aux.Stringid(101010285,0)) then
			Duel.BreakEffect()
			Duel.Damage(1-tp,dam,REASON_EFFECT)
		end
	end
end
