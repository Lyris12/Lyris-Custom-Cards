--Relay Procedure
function c481.initial_effect(c)
	if not c481.global_check then
		c481.global_check=true
		--register
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetOperation(c481.op)
		Duel.RegisterEffect(e1,0)
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(c481.recount)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ATTACK_DISABLED)
		ge2:SetOperation(c481.recheck)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_BATTLED)
		ge3:SetOperation(c481.recount2)
		Duel.RegisterEffect(ge3,0)
	end
end
function c481.regfilter(c)
	return c.relay
end
function c481.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c481.regfilter,0,LOCATION_EXTRA,LOCATION_EXTRA,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(481)==0 then
			local rl=Effect.CreateEffect(c)
			rl:SetType(EFFECT_TYPE_SINGLE)
			rl:SetCode(EFFECT_SPSUMMON_CONDITION)
			rl:SetRange(LOCATION_EXTRA)
			rl:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			rl:SetValue(c481.splimit)
			c:RegisterEffect(rl)
			local pt=Effect.CreateEffect(c)
			pt:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			pt:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			pt:SetCode(EVENT_PREDRAW)
			pt:SetRange(0xff)
			pt:SetCountLimit(1)
			pt:SetOperation(c481.ipoint)
			c:RegisterEffect(pt)
			--redirect
			local ge0=Effect.CreateEffect(c)
			ge0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			ge0:SetCode(EFFECT_SEND_REPLACE)
			ge0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			ge0:SetRange(LOCATION_ONFIELD)
			ge0:SetTarget(c481.reen)
			ge0:SetOperation(c481.reenop)
			c:RegisterEffect(ge0)
			--[[counter
			if not relay_check then
				relay_check=true
				local ge1=Effect.CreateEffect(c)
				ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
				ge1:SetOperation(481.recount)
				Duel.RegisterEffect(ge1,0)
				local ge2=Effect.CreateEffect(c)
				ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				ge2:SetCode(EVENT_ATTACK_DISABLED)
				ge2:SetOperation(c481.recheck)
				Duel.RegisterEffect(ge2,0)
				local ge3=Effect.CreateEffect(c)
				ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				ge3:SetCode(EVENT_BATTLED)
				ge3:SetOperation(c481.recount2)
				Duel.RegisterEffect(ge3,0)
			end]]
			--relay summon
			local ge4=Effect.CreateEffect(c)
			ge4:SetDescription(aux.Stringid(481,4))
			ge4:SetType(EFFECT_TYPE_FIELD)
			ge4:SetCode(EFFECT_SPSUMMON_PROC_G)
			ge4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			ge4:SetRange(LOCATION_EXTRA)
			ge4:SetCountLimit(1,10001000)
			ge4:SetCondition(c481.rescon)
			ge4:SetOperation(c481.resop)
			ge4:SetValue(0x8773)
			c:RegisterEffect(ge4)
			--check collected points
			local ge5=Effect.CreateEffect(c)
			ge5:SetDescription(aux.Stringid(481,2))
			ge5:SetType(EFFECT_TYPE_IGNITION)
			ge5:SetRange(LOCATION_MZONE)
			ge5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_BOTH_SIDE)
			ge5:SetTarget(c481.pointchk)
			ge5:SetOperation(c481.point)
			c:RegisterEffect(ge5)
			tc:RegisterFlagEffect(481,0,0,1)  
		end
		tc=g:GetNext()
	end
end
function c481.ipoint(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetTurnCount()==1 and c:GetFlagEffect(10001100)==0 then
		c:RegisterFlagEffect(10001100,0,EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE,1,c.point,aux.Stringid(481,1))
	end
end
function c481.pointchk(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(10001100)>0 and not c:IsStatus(STATUS_CHAINING) end
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end
function c481.point(e,tp,eg,ep,ev,re,r,rp)
	Debug.ShowHint("Number of Points: " .. tostring(e:GetHandler():GetFlagEffectLabel(10001100)))
end
function c481.reen(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local loc=LOCATION_DECK
	if c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ) then loc=loc+LOCATION_HAND end
	if chk==0 then return bit.band(c:GetDestination(),loc)~=0 end
	Duel.PSendtoExtra(c,c:GetOwner(),r)
	return true
end
function c481.recount(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local ct=tc:GetFlagEffectLabel(10001000)
	if ct then
		tc:SetFlagEffectLabel(10001000,ct+1)
	else
		tc:RegisterFlagEffect(10001000,RESET_PHASE+PHASE_END,0,1,1)
	end
end
function c481.recheck(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local ct=tc:GetFlagEffectLabel(10001000)
	if ct then
		tc:SetFlagEffectLabel(10001000,0)
	end
end
function c481.recount2(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,10001000,RESET_PHASE+PHASE_END,0,1)
end
function c481.resfilter(c)
	if c:IsLocation(LOCATION_REMOVED) and c:IsFacedown() then return false end
	return c:GetFlagEffect(10001000)>0 and c:GetFlagEffectLabel(10001000)>0 and c:IsAbleToDeck() and not c.relay
end
function c481.rescon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c481.resfilter,tp,0xbe,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=-g:FilterCount(Card.IsLocation,nil,LOCATION_MZONE) then return false end
	return g:GetCount()>0 and Duel.IsExistingMatchingCard(c481.refilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
end
function c481.fdfilter(c)
	return c:IsFacedown() or c:IsLocation(LOCATION_HAND)
end
function c481.refilter(c)
	return c:IsFaceup() and c.relay and not c:IsForbidden()
end
function c481.refilter1(c)
	return not c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ) and c481.refilter(c)
end
function c481.refilter2(c)
	return c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ) and c481.refilter(c)
end
function c481.resop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local g=Duel.GetMatchingGroup(c481.resfilter,tp,0xbe,0,nil)
	local fg=g:Filter(c481.fdfilter,nil)
	if fg:GetCount()>0 then Duel.ConfirmCards(1-tp,fg) end
	local mg=g:Clone()
	local pt2=0
	while mg:GetCount()>0 do
		local tc=mg:Select(tp,1,1,nil)
		pt2=pt2+1
		Duel.SendtoDeck(tc,tp,1,REASON_MATERIAL+0x8773)
		mg:Sub(tc)
	end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsExistingMatchingCard(c481.refilter1,tp,LOCATION_EXTRA,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(481,5)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local rg=Duel.SelectMatchingCard(tp,c481.refilter1,tp,LOCATION_EXTRA,0,1,ft,nil)
		sg:Merge(rg)
	end
	if (not rg or ft>rg:GetCount()) and Duel.IsExistingMatchingCard(c481.refilter2,tp,LOCATION_EXTRA,0,1,nil) and (not rg or Duel.SelectYesNo(tp,aux.Stringid(481,1))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local pc=Duel.SelectMatchingCard(tp,c481.refilter2,tp,LOCATION_EXTRA,0,1,1,nil)
		sg:Merge(pc)
	end
	local sc=sg:GetFirst()
	while sc do
		sc:SetMaterial(g)
		local pt1=Duel.GetFlagEffect(tp,10001000)
		local e1=Effect.CreateEffect(sc)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetLabel(pt1+pt2)
		e1:SetOperation(c481.pointop)
		sc:RegisterEffect(e1)
		sc=sg:GetNext()
	end
end
function c481.pointop(e,tp,eg,ep,ev,re,r,rp)
	local pt=e:GetLabel()
	local c=e:GetHandler()
	local point=c:GetFlagEffectLabel(10001100)
	if not point then
		c:RegisterFlagEffect(10001100,0,EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE,1,pt,aux.Stringid(481,0))
	else
		c:SetFlagEffectLabel(10001100,point+pt)
	end
end