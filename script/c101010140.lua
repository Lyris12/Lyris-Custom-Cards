--F・HEROネクロガイ
function c101010140.initial_effect(c)
--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_TRAP)
	c:RegisterEffect(e1)
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101010140,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c101010140.actcon)
	e2:SetTarget(c101010140.acttg)
	e2:SetOperation(c101010140.act)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(101010140,1))
	e3:SetCode(EVENT_CHAINING)
	c:RegisterEffect(e3)
	--During your Main Phase, if this card is in face-up Defense Position: You can target 1 face-up monster your opponent controls; banish that target, and if you do, banish all monsters you control.
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_REMOVE)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCountLimit(1,101010140)
	e0:SetCondition(c101010140.condition)
	e0:SetCost(c101010140.cost)
	e0:SetTarget(c101010140.target)
	e0:SetOperation(c101010140.operation)
	c:RegisterEffect(e0)
end
function c101010140.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPosition(POS_FACEUP_DEFENSE)
end
function c101010140.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_BATTLE_PHASE)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c101010140.filter(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function c101010140.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(c101010140.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c101010140.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c101010140.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and Duel.Remove(tc,tc:GetPosition(),REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local g=Group.FromCards(tc)
		local yg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,0,nil)
		if Duel.Remove(yg,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
			local rg=yg:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
			g:Merge(rg)
		end
		local oc=g:GetFirst()
		while oc do
			oc:RegisterFlagEffect(101010140,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
			oc=g:GetNext()
		end
		g:KeepAlive()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabelObject(g)
		e1:SetOperation(c101010140.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c101010140.actcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_SET_TURN) or e:GetHandler():GetFlagEffect(101010091)~=0
end
function c101010140.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101010140.act(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
		if ev~=0 then
			local ef=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
			if ef~=nil and ef:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then Card.ReleaseEffectRelation(c,ef) end
		end
		c101010140.after(e,tp)
	end
end
function c101010140.after(e,tp)
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(101010140,2)) then
		local tc=g:Select(tp,1,1,nil)
		Duel.HintSelection(tc)
		Duel.BreakEffect()
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c101010140.retfilter(c,e,tp)
	return c:GetFlagEffect(101010140)~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101010140.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	local g=e:GetLabelObject()
	local sg=g:Filter(c101010140.retfilter,nil,e,tp)
	g:DeleteGroup()
	local ct=0
	if sg:GetCount()>0 then
		local tc=sg:GetFirst()
		while tc do
			if Duel.GetLocationCount(tc:GetOwner(),LOCATION_MZONE)<=0 then break end
			Duel.SpecialSummonStep(tc,0,tp,tc:GetOwner(),false,false,POS_FACEUP)
			tc=sg:GetNext()
			ct=ct+1
		end
	end
	if ct>0 then Duel.SpecialSummonComplete() end
end
