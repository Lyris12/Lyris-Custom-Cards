--Harmony Procedure
function c531.initial_effect(c)
	if not c531.global_check then
		c531.global_check=true
		--register
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_ADJUST)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetOperation(c531.op)
		Duel.RegisterEffect(e2,0)
	end
end
function c531.filterx(c)
	return c.harmony
end
function c531.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c531.filterx,0,LOCATION_EXTRA,LOCATION_EXTRA,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:IsLocation(LOCATION_DECK) then Duel.DisableShuffleCheck() Duel.SendtoHand(tc,nil,REASON_RULE) end
		if tc:GetFlagEffect(531)==0 then
			tc:EnableReviveLimit()
			local ge0=Effect.CreateEffect(tc)
			ge0:SetType(EFFECT_TYPE_SINGLE)
			ge0:SetCode(EFFECT_SPSUMMON_CONDITION)
			ge0:SetRange(LOCATION_EXTRA)
			ge0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			ge0:SetValue(c481.splimit)
			tc:RegisterEffect(ge0)
			--check banished card
			if not harmony_track then
				harmony_track=true
				local ge1=Effect.CreateEffect(tc)
				ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				ge1:SetCode(EVENT_REMOVE)
				ge1:SetOperation(c531.ctbgn)
				Duel.RegisterEffect(ge1,0)
				local ge2=Effect.CreateEffect(tc)
				ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				ge2:SetCode(EVENT_PHASE+0x287)
				ge2:SetOperation(c531.count)
				Duel.RegisterEffect(ge2,0)
			end
			--special summon
			local ge3=Effect.CreateEffect(tc)
			ge3:SetType(EFFECT_TYPE_FIELD)
			ge3:SetCode(EFFECT_SPSUMMON_PROC)
			ge3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			ge3:SetRange(LOCATION_EXTRA)
			ge3:SetCondition(c531.spcon)
			ge3:SetOperation(c531.spop)
			ge3:SetValue(0x1000)
			tc:RegisterEffect(ge3)
			--proper Special Summon
			local ge4=Effect.CreateEffect(tc)
			ge4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			ge4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			ge4:SetCode(EVENT_SPSUMMON_SUCCESS)
			ge4:SetReset(RESET_EVENT+EVENT_ADJUST,1)
			ge4:SetCondition(function(e) return bit.band(e:GetHandler():GetSummonType(),0x1000)==0x1000 end)
			ge4:SetOperation(function(e) e:GetHandler():CompleteProcedure() end)
			tc:RegisterEffect(ge4)
			--
			local ge5=Effect.CreateEffect(tc)
			ge5:SetType(EFFECT_TYPE_SINGLE)
			ge5:SetCode(EFFECT_REMOVE_TYPE)
			ge5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
			ge5:SetReset(RESET_EVENT+EVENT_ADJUST,1)
			ge5:SetValue(TYPE_SYNCHRO)
			tc:RegisterEffect(ge5)
			tc:RegisterFlagEffect(531,RESET_EVENT+EVENT_ADJUST,0,1)  
		end
		tc=g:GetNext()
	end
end
function c531.splimit(e,se,sp,st)
	return bit.band(st,0x1000)==0x1000
end
function c531.ctbgn(e,tp,eg,ep,ev,re,r,rp)
	local ct=1
	if Duel.GetTurnPlayer()~=tp then ct=0 end
	local tc=eg:GetFirst()
	while tc do
		tc:RegisterFlagEffect(10002000,RESET_EVENT+0x1fe0000,0,1,ct)
		tc=eg:GetNext()
	end
end
function c531.cfilter(c)
	return c:GetFlagEffect(10002000)>0
end
function c531.count(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return end
	local g=Duel.GetMatchingGroup(c531.cfilter,tp,LOCATION_REMOVED,0,nil)
	local tc=g:GetFirst()
	local ct=0
	while tc do
		tc:SetFlagEffectLabel(10002000,tc:GetFlagEffectLabel(10002000)+1)
		tc=g:GetNext()
	end
end
function c531.matfilter(c,x,f)
	return c:GetFlagEffectLabel(10002000) and c:GetFlagEffectLabel(10002000)>=x and (not f or f(c))
		and c:IsAbleToDeck()
end
function c531.spcon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local rt=1
	if c.material_count then ct=c.material_count end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c531.matfilter,tp,LOCATION_REMOVED,0,1,nil,c:GetLevel(),c.material)
end
function c531.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c531.matfilter,tp,LOCATION_REMOVED,0,1,1,nil,c:GetLevel(),c.material)
	c:SetMaterial(g)
	Duel.SendtoDeck(g,nil,2,REASON_MATERIAL+0x40000000)
end
