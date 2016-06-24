--Impure Procedure
function c357.initial_effect(c)
	if not c357.global_check then
		c357.global_check=true
		--register
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_ADJUST)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetOperation(c357.op)
		Duel.RegisterEffect(e2,0)
	end
end
function c357.filterx(c)
	return c.impure
end
function c357.filteri(c)
	return c:GetFlagEffect(6507)~=0
end
function c357.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:GetOverlayGroup():IsExists(c357.filteri,1,nil) then return end
	local og=c:GetOverlayGroup():Filter(c357.filteri,nil)
	og:KeepAlive()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetLabel(c:GetCode())
	e2:SetLabelObject(og)
	e2:SetTarget(c357.sbtg)
	e2:SetOperation(c357.sbop)
	c:RegisterEffect(e2)
end
function c357.sbtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) end
	Duel.SetChainLimit(aux.FALSE)
end
function c357.sbop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local token=Duel.CreateToken(tp,357,0,0,0,c:GetPreviousRankOnField(),c:GetPreviousRaceOnField(),c:GetPreviousAttributeOnField())
	local e1=Effect.CreateEffect(token)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetValue(e:GetLabel())
	token:RegisterEffect(e1)
	local e2=Effect.CreateEffect(token)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCountLimit(1)
	e2:SetOperation(c357.epop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	token:RegisterEffect(e2)
	local e3=Effect.CreateEffect(token)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetLabel(e:GetLabel())
	e3:SetOperation(c357.sbop)
	e3:SetReset(RESET_PHASE+PHASE_END)
	token:RegisterEffect(e3)
	local g=e:GetLabelObject()
	if g then
		g:DeleteGroup()
		g:KeepAlive()
		e3:SetLabelObject(g)
		Duel.MoveToField(token,tp,tp,LOCATION_MZONE,POS_FACEUP_DEFENCE,true)
		Duel.Overlay(token,g)
	end
end
function c357.epop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	local g=c:GetOverlayGroup()
	local tc=g:GetFirst()
	while tc do
		Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEUP,true)
	end
	if c:GetOverlayCount()==0 then
		Duel.Remove(c,POS_FACEUP,REASON_RULE)
	end
end
function c357.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c357.filterx,0,LOCATION_EXTRA,LOCATION_EXTRA,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(357)==0 then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_SPSUMMON_PROC)
			e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e2:SetDescription(aux.Stringid(357,0))
			e2:SetRange(LOCATION_EXTRA)
			e2:SetValue(0x6507)
			e2:SetCondition(c357.sumcon)
			e2:SetOperation(c357.sumop)
			e2:SetReset(RESET_EVENT+EVENT_ADJUST,1)
			tc:RegisterEffect(e2)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_REMOVE_TYPE)
			e2:SetTarget(function(e) return e:GetHandler():IsLocation(LOCATION_MZONE,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA) end)
			e2:SetValue(TYPE_XYZ)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_LEAVE_FIELD_P)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetOperation(c357.spop)
			tc:RegisterEffect(e3)
			tc:RegisterFlagEffect(357,RESET_EVENT+EVENT_ADJUST,0,1)
		end
		tc=g:GetNext()
	end
end
function c357.matfilter(c,ipr,tp)
	return ipr.material and ipr.material(c) and c:IsCanTurnSet()
end
function c357.sumcon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c357.matfilter,tp,LOCATION_MZONE,0,nil,c)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and mg:GetCount()>0
end
function c357.sumop(e,tp,eg,ep,ev,re,r,rp,c,og)
	local mg=Duel.GetMatchingGroup(c357.matfilter,tp,LOCATION_MZONE,0,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(357,1))
	local sg=mg:Select(tp,1,1,nil)
	c:SetMaterial(sg)
	Duel.ChangePosition(sg,POS_FACEDOWN_DEFENCE)
	Duel.Overlay(c,sg)
	local tc=sg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e1:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e1)
		tc=sg:GetNext()
	end
end
