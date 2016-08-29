--Starry-Eyes Stripe Dragon
function c101010363.initial_effect(c)
	--If this face-up card would be banished, return it to the Extra Deck instead.
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EFFECT_SEND_REPLACE)
	e0:SetTarget(c101010363.reptg)
	c:RegisterEffect(e0)
	--You can dispose 1 of this card's Points, then target 1 banished monster; shuffle that target into the Deck, then all monsters your opponent controls lose ATK and DEF equal to its ATK or DEF in the Deck (whichever is higher).
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetCost(c101010363.cost)
	e1:SetTarget(c101010363.target)
	e1:SetOperation(c101010363.operation)
	c:RegisterEffect(e1)
	--special summon (Do Not Remove)
	c:EnableReviveLimit()
	local ge0=Effect.CreateEffect(c)
	ge0:SetType(EFFECT_TYPE_FIELD)
	ge0:SetCode(EFFECT_SPSUMMON_PROC)
	ge0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	ge0:SetRange(LOCATION_EXTRA)
	ge0:SetCondition(c101010363.spcon)
	ge0:SetOperation(c101010363.spop)
	ge0:SetValue(SUMMON_TYPE_XYZ+7150)
	c:RegisterEffect(ge0)
	local ge3=Effect.CreateEffect(c)
	ge3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	ge3:SetType(EFFECT_TYPE_SINGLE)
	ge3:SetRange(LOCATION_EXTRA)
	ge3:SetCode(EFFECT_SPSUMMON_CONDITION)
	ge3:SetValue(function(e,se,ep,st) return bit.band(st,SUMMON_TYPE_XYZ+7150)==SUMMON_TYPE_XYZ+7150 end)
	c:RegisterEffect(ge3)
	--cannot Grave (Do Not Remove)
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD)
	ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_RANGE)
	ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	ge1:SetTargetRange(LOCATION_ONFIELD+LOCATION_OVERLAY,0)
	ge1:SetTarget(function(e,c) return c==e:GetHandler() end)
	ge1:SetValue(LOCATION_REMOVED)
	Duel.RegisterEffect(ge1,0)
	if not c101010363.global_check then
		c101010363.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c101010363.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
c101010363.relay=true
c101010363.point=1
function c101010363.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,481)
	Duel.CreateToken(1-tp,481)
end
function c101010363.spfilter(c,tp)
	return c:IsAbleToRemoveAsCost() and c.spatial and Duel.IsExistingMatchingCard(c101010363.spfilter2,tp,LOCATION_MZONE,0,1,c)
end
function c101010363.spfilter2(c)
	return c:IsAbleToRemoveAsCost() and c.relay
end
function c101010363.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2 and Duel.IsExistingMatchingCard(c101010363.spfilter,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c101010363.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,c101010363.spfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cd=tc:GetFirst()
	local g2=Duel.SelectMatchingCard(tp,c101010363.spfilter2,tp,LOCATION_MZONE,0,1,1,cd)
	tc:Merge(g2)
	c:SetMaterial(tc)
	local fg=tc:Filter(Card.IsFacedown,nil)
	if fg:GetCount()>0 then Duel.ConfirmCards(1-tp,fg) end
	local atk=10
	local rg=tc:GetFirst()
	while rg do
		local atk1=rg:GetDefense()
		atk=atk+atk1
		rg=tc:GetNext()
	end
	Duel.Remove(tc,POS_FACEUP,REASON_MATERIAL+7150)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_DEFENSE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(atk)
	c:RegisterEffect(e1)
end
function c101010363.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsFaceup() and c:IsOnField() and c:GetDestination()==LOCATION_REMOVED end
	if Duel.SendtoDeck(c,nil,2,REASON_EFFECT)~=0 then
		return true
	else return false end
end
function c101010363.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local point=c:GetFlagEffectLabel(10001100)
	if chk==0 then return c:GetFlagEffect(10001100)>=1 end
	if point==1 then
		c:ResetFlagEffect(10001100)
	else
		c:SetFlagEffectLabel(10001100,point-1)
	end
end
function c101010363.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c101010363.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c101010363.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101010363.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c101010363.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c101010363.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e)
		and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0
		and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
		local atk=tc:GetAttack()
		local c=e:GetHandler()
		local tg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		local oc=tg:GetFirst()
		if atk>0 and oc then
			Duel.BreakEffect()
			while oc do
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(-atk)
				e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				oc:RegisterEffect(e1)
				oc=tg:GetNext()
			end
		end
	end
end
