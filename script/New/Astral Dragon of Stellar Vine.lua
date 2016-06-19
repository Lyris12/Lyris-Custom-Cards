--Astral Dragon of Stellar Vine
function c101010239.initial_effect(c)
	--special summon (Do Not Remove)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,20001000)
	e1:SetCondition(c101010239.spcon)
	e1:SetOperation(c101010239.spop)
	e1:SetValue(0x7150)
	c:RegisterEffect(e1)
	--Do Not Remove
	local ad=Effect.CreateEffect(c)
	ad:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	ad:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ad:SetCode(EVENT_SPSUMMON_SUCCESS)
	ad:SetCondition(function(e) return bit.band(e:GetHandler():GetSummonType(),0x7150)==0x7150 end)
	ad:SetOperation(function(e) e:GetHandler():CompleteProcedure() end)
	c:RegisterEffect(ad)
	--cannot be XYZ (Do Not Remove)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e8)
	--identifier (Do Not Remove)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(20001000)
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
function c101010239.spfilter(c,x)
	return c:GetLevel()<x and c:IsAbleToRemoveAsCost()
end
function c101010239.sfilter1(c,x,g)
	local lv=c:GetLevel()
	local rk=c:GetRank()
	return g:IsExists(c101010239.sfilter2,1,c,x,lv,rk)
end
function c101010239.sfilter2(c,x,lv,rk)
	return c:GetLevel()+lv==x or c:GetLevel()+rk==x
end
function c101010239.spcon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-1 then return end
	local g=Duel.GetMatchingGroup(c101010239.spfilter,tp,LOCATION_MZONE,0,nil,x)
	return g:IsExists(c101010239.sfilter1,1,nil,x,g) and c:GetFlagEffect(01010239)==0
end
function c101010239.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Group.CreateGroup()
	local x=x
	local g=Duel.GetMatchingGroup(c101010239.spfilter,tp,LOCATION_MZONE,0,nil,x)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc1=g:FilterSelect(tp,c101010239.sfilter1,1,1,nil,x,g):GetFirst()
	mg:AddCard(tc1)
	local tc2=g:FilterSelect(tp,c101010239.sfilter2,1,1,tc1,x,tc1:GetLevel(),tc1:GetRank())
	mg:AddCard(tc2)
	c:SetMaterial(mg)
	local fg=mg:Filter(Card.IsFacedown,nil)
	if fg:GetCount()>0 then Duel.ConfirmCards(1-tp,fg) end
	Duel.Remove(mg,POS_FACEUP,REASON_MATERIAL+0x7150)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_DECK)
	e1:SetOperation(c101010239.splimit)
	e1:SetReset(RESET_EVENT+RESET_TODECK)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetLabel(10)
	e2:SetTarget(c101010239.reptg)
	e2:SetReset(RESET_EVENT+RESET_TODECK)
	c:RegisterEffect(e2)
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
function c101010239.splimit(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(01010239,RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,2)
end
function c101010239.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetDestination()==LOCATION_GRAVE end
	local ck=false
	if Duel.CheckEvent(EVENT_SPSUMMON) or c:GetRank()<=1 or c:IsLocation(LOCATION_OVERLAY) then ck=true end
	if ck then
		if Duel.Remove(c,POS_FACEUP,r)==0 then
			Duel.BreakEffect() 
			Duel.SendtoHand(c,nil,r)
			if not c:IsLocation(LOCATION_EXTRA) then
				Duel.SendtoDeck(c,nil,0,r)
			end
		end
		return true
	end
	local dje=e:GetLabel()
	e:SetLabel(dje-1)
	if c:GetFlagEffect(201010239)==0 then
		local e9=Effect.CreateEffect(c)
		e9:SetType(EFFECT_TYPE_SINGLE)
		e9:SetCode(EFFECT_CHANGE_RANK)
		e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e9:SetRange(LOCATION_MZONE)
		e9:SetValue(function(e) local djn=e:GetLabelObject():GetLabel() if djn~=0 then return djn end return 1 end)
		e9:SetLabelObject(e)
		c:RegisterEffect(e9)
		c:RegisterFlagEffect(201010239,RESET_EVENT+0x1fe0000,0,1)
	end
	return true
end
