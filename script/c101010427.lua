--Cyberspace Eclipse Dragon
local id,ref=GIR()
function ref.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,ref.xyzfilter,10,3,ref.ovfilter,aux.Stringid(101010341,0),3,nil)
	c:EnableReviveLimit()
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetCode(EFFECT_ADD_ATTRIBUTE)
	e6:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e6)
	--attach
	local e5=Effect.CreateEffect(c)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetOperation(ref.atop)
	c:RegisterEffect(e5)
	--negate(effect)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(ref.negcon)
	e3:SetCost(ref.negcost)
	e3:SetTarget(ref.negtg)
	e3:SetOperation(ref.negop)
	c:RegisterEffect(e3)
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(ref.condition1)
	e1:SetCost(ref.negcost)
	e1:SetTarget(ref.target1)
	e1:SetOperation(ref.activate1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e2)
	local e4=e1:Clone()
	e4:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e4)
end
function ref.xyzfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_MACHINE)
end
function ref.ovfilter(c)
	return c:IsFaceup() and c:IsCode(101010336)
end
function ref.filter1(c,tp)
	return c:IsRace(RACE_MACHINE) and not c:IsType(TYPE_TOKEN)
end
function ref.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,c31320433.matfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
		if g:GetCount()>=0 then
			Duel.Overlay(e:GetHandler(),g)
		end
	end
end
function ref.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function ref.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and e:GetHandler():GetFlagEffect(101010341)==0 end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	e:GetHandler():RegisterFlagEffect(101010341,RESET_PHASE+PHASE_END+RESET_EVENT+0x1fe0000,0,1)
end
function ref.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,ev,1,0,0)
end
function ref.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	local tc=re:GetHandler()
	if tc:IsRelateToEffect(re) then
		local pos=POS_FACEDOWN
		local event=EVENT_SSET
		if tc:IsLocation(LOCATION_SZONE) then
			tc:CancelToGrave()
			tc:SetStatus(STATUS_SET_TURN,true)
		else pos=POS_FACEDOWN_DEFENCE event=EVENT_MSET end
		Duel.ChangePosition(tc,pos,pos,pos,pos)
		Duel.RaiseEvent(tc,event,e,REASON_EFFECT,tp,tp,0)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
	end
end
function ref.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function ref.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
end
function ref.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.ChangePosition(eg,POS_FACEDOWN_DEFENCE,POS_FACEDOWN_DEFENCE,POS_FACEDOWN_DEFENCE,POS_FACEDOWN_DEFENCE)
	Duel.RaiseEvent(rc,EVENT_MSET,e,REASON_EFFECT,tp,tp,0)
end
