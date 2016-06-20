--Osa, Princess of Stellar Vine
function c101010238.initial_effect(c)
	--to grave
	local ae1=Effect.CreateEffect(c)
	ae1:SetCategory(CATEGORY_TOGRAVE)
	ae1:SetType(EFFECT_TYPE_IGNITION)
	ae1:SetRange(LOCATION_MZONE)
	ae1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ae1:SetCountLimit(1)
	ae1:SetCost(c101010238.cost)
	ae1:SetTarget(c101010238.target)
	ae1:SetOperation(c101010238.op)
	c:RegisterEffect(ae1)
	--special summon (Do Not Remove)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,20003000)
	e1:SetCondition(c101010238.spcon)
	e1:SetOperation(c101010238.spop)
	e1:SetValue(7150)
	c:RegisterEffect(e1)
	--cannot be XYZ (Do Not Remove)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e8)
	--identifier
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(20003000)
	c:RegisterEffect(e9)
	--cannot Grave (Do Not Remove)
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD)
	ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_RANGE)
	ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	ge1:SetTargetRange(0xff,0)
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
function c101010238.spfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c101010238.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2 and Duel.IsExistingMatchingCard(c101010238.spfilter,tp,LOCATION_MZONE,0,2,nil) and c:GetFlagEffect(743000003)==0
end
function c101010238.succon(e)
	return bit.band(e:GetHandler():GetSummonType(),7150)==7150
end
function c101010238.sucop(e)
	e:GetHandler():CompleteProcedure()
	local atk=e:GetLabelObject():GetLabel()
	local c=e:GetHandler()
end
function c101010238.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c101010238.spfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=g:Select(tp,2,2,nil)
	c:SetMaterial(tc)
	local fg=tc:Filter(Card.IsFacedown,nil)
	if fg:GetCount()>0 then Duel.ConfirmCards(1-tp,fg) end
	local atk=0
	local def=0
	local rg=tc:GetFirst()
	while rg do
		local atk1=rg:GetAttack()
		local def1=rg:GetDefence()
		atk=atk+atk1
		def=def+def1
		rg=tc:GetNext()
	end
	Duel.Remove(g,POS_FACEUP,REASON_MATERIAL+0x7150)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SET_BASE_ATTACK)
	e0:SetReset(RESET_EVENT+0xfe0000)
	e0:SetValue(atk)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetCode(EFFECT_SET_BASE_DEFENCE)
	e1:SetValue(def)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetOperation(c101010238.splimit)
	e2:SetReset(RESET_EVENT+RESET_TODECK)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetLabel(3)
	e3:SetTarget(c101010238.reptg)
	e3:SetReset(RESET_EVENT+0x1fe0000)
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
function c101010238.spatial(c)
	return c:IsType(TYPE_XYZ) and (c:IsHasEffect(20001000) or c:IsHasEffect(20002000) or c:IsHasEffect(20003000) or c:IsHasEffect(20004000))
end
function c101010238.splimit(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(743000003,RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,2)
end
function c101010238.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
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
	if c:GetFlagEffect(201010238)==0 then
		local e9=Effect.CreateEffect(c)
		e9:SetType(EFFECT_TYPE_SINGLE)
		e9:SetCode(EFFECT_CHANGE_RANK)
		e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e9:SetRange(LOCATION_MZONE)
		e9:SetValue(function(e) local djn=e:GetLabelObject():GetLabel() if djn~=0 then return djn end return 1 end)
		e9:SetLabelObject(e)
		c:RegisterEffect(e9)
		c:RegisterFlagEffect(201010238,RESET_EVENT+0x1fe0000,0,1)
	end
	return true
end
function c101010238.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckOrExtraAsCost()
end
function c101010238.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010238.cfilter,tp,LOCATION_REMOVED,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c101010238.cfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c101010238.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x785e) and c:IsAbleToGraveAsCost()
end
function c101010238.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c101010238.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101010238.filter,tp,LOCATION_REMOVED,0,4,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101010238,0))
	local g=Duel.SelectTarget(tp,c101010238.filter,tp,LOCATION_REMOVED,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c101010238.op(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
	Duel.SendtoGrave(tg,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
	if ct==3 and Duel.SelectYesNo(tp,aux.Stringid(101010238,1)) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
