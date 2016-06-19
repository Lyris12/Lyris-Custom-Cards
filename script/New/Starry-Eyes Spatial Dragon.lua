--Starry-Eyes Spatial Dragon
function c101010236.initial_effect(c)
	--attack banish
	local ae1=Effect.CreateEffect(c)
	ae1:SetCategory(CATEGORY_TOGRAVE)
	ae1:SetType(EFFECT_TYPE_IGNITION)
	ae1:SetRange(LOCATION_MZONE)
	ae1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ae1:SetCountLimit(1)
	ae1:SetCost(c101010236.bancon)
	ae1:SetTarget(c101010236.bantg)
	ae1:SetOperation(c101010236.banop)
	c:RegisterEffect(ae1)
	--special summon (Do Not Remove)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,20004000)
	e1:SetCondition(c101010236.spcon)
	e1:SetOperation(c101010236.spop)
	e1:SetValue(0x7150)
	c:RegisterEffect(e1)
	--cannot release (Do Not Remove)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_UNRELEASABLE_SUM)
	e5:SetValue(function(e) return e:GetHandler():GetRank()>1 end)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EFFECT_UNRELEASABLE_EFFECT)
	c:RegisterEffect(e7)
	--cannot be XYZ (Do Not Remove)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e8)
	--identifier
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(20004000)
	c:RegisterEffect(e9)
	--cannot Grave (Do Not Remove)
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD)
	ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_RANGE)
	ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	ge1:SetTargetRange(LOCATION_OVERLAY,0)
	ge1:SetTarget(function(e,c) return c==e:GetHandler() end)
	ge1:SetValue(LOCATION_REMOVED)
	Duel.RegisterEffect(ge1,0)
	local ge2=Effect.CreateEffect(c)
	ge2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	ge2:SetCode(EVENT_TO_GRAVE)
	ge2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ge2:SetOperation(function(e) local c=e:GetHandler() Duel.SendtoHand(c,nil,REASON_RULE) if not c:IsLocation(LOCATION_EXTRA) then Duel.SendtoDeck(c,nil,0,REASON_RULE) end end)
	c:RegisterEffect(ge2)
end
function c101010236.spfilter(c)
	if not c:IsAbleToRemoveAsCost() then return false end
	if c:IsRankAbove(1) then return false end
	local atk=c:GetAttack()
	local lv=c:GetLevel()
	local st1=atk
	local st2=lv
	local mhb=st1/st2
	while mhb>=10 or mhb<1 do
		while mhb>=10 do mhb=mhb/10 end
		while mhb<1 do mhb=mhb*10 end
	end
	local mhc=mhb-math.floor(mhb)
	if mhc>=0.5 then mhb=math.ceil(mhb) else mhb=math.floor(mhb) end
	return mhb==7 or mhb==math.ceil(7/2) or mhb==math.floor(7/2)
end
function c101010236.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c101010236.spfilter,tp,LOCATION_MZONE,0,1,nil) and c:GetFlagEffect(743000003)==0
end
function c101010236.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ec=Duel.GetMatchingGroup(c101010236.spatial,tp,LOCATION_MZONE,0,nil)
	if ec:GetCount()>0 then Duel.Remove(ec,POS_FACEUP,REASON_EFFECT) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101010236.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
	c:SetMaterial(g)
	local fg=g:Filter(Card.IsFacedown,nil)
	if fg:GetCount()>0 then Duel.ConfirmCards(1-tp,fg) end
	Duel.Remove(g,POS_FACEUP,REASON_MATERIAL+0x7150)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_DECK)
	e1:SetOperation(c101010236.splimit)
	e1:SetReset(RESET_EVENT+RESET_TODECK)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetLabel(7)
	e3:SetTarget(c101010236.reptg)
	e3:SetReset(RESET_EVENT+RESET_TODECK)
	c:RegisterEffect(e3)
	--cannot release (Do Not Remove)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_UNRELEASABLE_SUM)
	e5:SetValue(function(e) return e:GetHandler():GetRank()>1 end)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EFFECT_UNRELEASABLE_EFFECT)
	c:RegisterEffect(e7)
end
function c101010236.spatial(c)
	return c:IsType(TYPE_XYZ) and (c:IsHasEffect(20001000) or c:IsHasEffect(20002000) or c:IsHasEffect(20003000) or c:IsHasEffect(20004000))
end
function c101010236.splimit(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(743000003,RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,2)
end
function c101010236.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetDestination()==LOCATION_GRAVE end
	local ck=false
	if Duel.CheckEvent(EVENT_SPSUMMON) or c:GetRank()<=1 or c:IsLocation(LOCATION_OVERLAY) then ck=true end
	if ck then
		if Duel.Remove(c,POS_FACEUP,r)==0 then
			Duel.BreakEffect()
			Duel.SendtoHand(c,nil,r)
			if not c:IsLocation(LOCATION_EXTRA) then
				Duel.BreakEffect()
				Duel.SendtoDeck(c,nil,0,r)
			end
		end
		return true
	end
	local dje=e:GetLabel()
	e:SetLabel(dje-1)
	if c:GetFlagEffect(201010236)==0 then
		local e9=Effect.CreateEffect(c)
		e9:SetType(EFFECT_TYPE_SINGLE)
		e9:SetCode(EFFECT_CHANGE_RANK)
		e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e9:SetRange(LOCATION_MZONE)
		e9:SetValue(function(e) local djn=e:GetLabelObject():GetLabel() if djn~=0 then return djn end return 1 end)
		e9:SetLabelObject(e)
		c:RegisterEffect(e9)
		c:RegisterFlagEffect(201010236,RESET_EVENT+0x1fe0000,0,1)
	end
	return true
end
function c101010236.bancon(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCurrentPhase()==PHASE_MAIN1 end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1,true)
end
function c101010236.atkfilter(c,atk)
	local gr=c:IsAbleToGrave()
	local def=c:GetBaseDefence()
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and ((atk>=c:GetBaseAttack() and gr) or (atk==def or (atk>def and gr)))
end
function c101010236.bantg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(1-tp) and c101010236.atkfilter(chkc,c:GetAttack()) end
	if chk==0 then return Duel.IsExistingTarget(c101010236.atkfilter,tp,0,LOCATION_REMOVED,1,nil,c:GetAttack()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c101010236.atkfilter,tp,0,LOCATION_REMOVED,1,1,nil,c:GetAttack())
	local atk=g:GetFirst():GetBaseAttack()
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
	if not g:GetFirst():IsAbleToGrave() then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	end
end
function c101010236.banop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Damage(1-tp,tc:GetBaseAttack(),REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		if c:IsRelateToEffect(e) and tc:GetBaseAttack()==c:GetAttack() then
			Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
		end
		if tc:GetBaseDefence()>=c:GetAttack() then return end
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
