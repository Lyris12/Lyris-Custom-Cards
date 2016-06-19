--Victory Dragon Ariesen
function c101010401.initial_effect(c)
	c:EnableReviveLimit()
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c101010401.aclimit)
	e1:SetCondition(c101010401.actcon)
	c:RegisterEffect(e1)
	--dispose
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetLabel(1)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_BATTLE and not Duel.CheckTiming(TIMING_BATTLE_START+TIMING_BATTLE_END) end)
	e2:SetCost(c101010401.cost)
	e2:SetTarget(c101010401.sptg)
	e2:SetOperation(c101010401.spop)
	c:RegisterEffect(e2)
	--Do Not Remove
	local rl=Effect.CreateEffect(c)
	rl:SetType(EFFECT_TYPE_SINGLE)
	rl:SetCode(EFFECT_SPSUMMON_CONDITION)
	rl:SetRange(LOCATION_EXTRA)
	rl:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	rl:SetValue(aux.synlimit)
	c:RegisterEffect(rl)
	--Do Not Remove
	local point=Effect.CreateEffect(c)
	point:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	point:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	point:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	point:SetRange(0xff)
	point:SetCountLimit(1)
	point:SetOperation(c101010401.ipoint)
	c:RegisterEffect(point)
	--redirect
	local ge0=Effect.CreateEffect(c)
	ge0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	ge0:SetCode(EFFECT_SEND_REPLACE)
	ge0:SetRange(LOCATION_ONFIELD)
	ge0:SetTarget(c101010401.reen)
	ge0:SetOperation(c101010401.reenop)
	c:RegisterEffect(ge0)
	--counter
	if not relay_check then
		relay_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(c101010401.recount)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ATTACK_DISABLED)
		ge2:SetOperation(c101010401.recheck)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_BATTLED)
		ge3:SetOperation(c101010401.recount2)
		Duel.RegisterEffect(ge3,0)
	end
	--relay summon
	local ge4=Effect.CreateEffect(c)
	ge4:SetDescription(aux.Stringid(101010401,4))
	ge4:SetType(EFFECT_TYPE_FIELD)
	ge4:SetCode(EFFECT_SPSUMMON_PROC_G)
	ge4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	ge4:SetRange(LOCATION_EXTRA)
	ge4:SetCountLimit(1,10001000)
	ge4:SetCondition(c101010401.rescon)
	ge4:SetOperation(c101010401.resop)
	ge4:SetValue(0x8773)
	c:RegisterEffect(ge4)
	--check collected points
	local ge5=Effect.CreateEffect(c)
	ge5:SetDescription(aux.Stringid(101010401,2))
	ge5:SetType(EFFECT_TYPE_IGNITION)
	ge5:SetRange(LOCATION_MZONE)
	ge5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_BOTH_SIDE)
	ge5:SetTarget(c101010401.pointchk)
	ge5:SetOperation(c101010401.point)
	c:RegisterEffect(ge5)
	--identifier
	local ge6=Effect.CreateEffect(c)
	ge6:SetType(EFFECT_TYPE_SINGLE)
	ge6:SetCode(10001000)
	c:RegisterEffect(ge6)
end
function c101010401.ipoint(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(10001100)==0 then
		c:RegisterFlagEffect(10001100,0,EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE,1,2,aux.Stringid(101010401,1))
	end
end
function c101010401.pointchk(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(10001100)>0 and not c:IsStatus(STATUS_CHAINING) end
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end
function c101010401.point(e,tp,eg,ep,ev,re,r,rp)
	Debug.ShowHint("Number of Points: " .. tostring(e:GetHandler():GetFlagEffectLabel(10001100)))
end
function c101010401.reen(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return bit.band(c:GetDestination(),LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)~=0 end
	if c:GetDestination()==LOCATION_GRAVE then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_TO_DECK)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) Duel.SendtoGrave(e:GetHandler(),REASON_RULE) end)
		c:RegisterEffect(e1)
	end
	Duel.PSendtoExtra(c,c:GetOwner(),r)
	return true
end
function c101010401.recount(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local ct=tc:GetFlagEffectLabel(10001000)
	if ct then
		tc:SetFlagEffectLabel(10001000,ct+1)
	else
		tc:RegisterFlagEffect(10001000,RESET_PHASE+PHASE_END,0,1,1)
	end
end
function c101010401.recheck(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local ct=tc:GetFlagEffectLabel(10001000)
	if ct then
		tc:SetFlagEffectLabel(10001000,0)
	end
end
function c101010401.recount2(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,10001000,RESET_PHASE+PHASE_END,0,1)
end
function c101010401.resfilter(c)
	if c:IsLocation(LOCATION_REMOVED) and c:IsFacedown() then return false end
	return c:GetFlagEffect(10001000)>0 and c:GetFlagEffectLabel(10001000)>0 and c:IsAbleToDeck() and not (c:IsType(TYPE_PENDULUM) and c:IsHasEffect(10001000))
end
function c101010401.rescon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c101010401.resfilter,tp,0xbe,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=-g:FilterCount(Card.IsLocation,nil,LOCATION_MZONE) then return false end
	return g:GetCount()>0 and Duel.IsExistingMatchingCard(c101010401.refilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
end
function c101010401.fdfilter(c)
	return c:IsFacedown() or c:IsLocation(LOCATION_HAND)
end
function c101010401.refilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
		and not c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsForbidden()
end
function c101010401.refilter1(c,e,tp)
	return not c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ) and c101010401.refilter(c,e,tp)
end
function c101010401.refilter2(c,e,tp)
	return c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ) and c101010401.refilter(c,e,tp)
end
function c101010401.resop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local g=Duel.GetMatchingGroup(c101010401.resfilter,tp,0xbe,0,nil)
	local fg=g:Filter(c101010401.fdfilter,nil)
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
	if Duel.IsExistingMatchingCard(c101010401.refilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(101010401,5)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local rg=Duel.SelectMatchingCard(tp,c101010401.refilter1,tp,LOCATION_EXTRA,0,1,ft,nil,e,tp)
		sg:Merge(rg)
	end
	if (not rg or ft>rg:GetCount()) and Duel.IsExistingMatchingCard(c101010401.refilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp) and (not rg or Duel.SelectYesNo(tp,aux.Stringid(101010401,1))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local pc=Duel.SelectMatchingCard(tp,c101010401.refilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
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
		e1:SetOperation(c101010401.pointop)
		sc:RegisterEffect(e1)
		sc=sg:GetNext()
	end
end
function c101010401.pointop(e,tp,eg,ep,ev,re,r,rp)
	local pt=e:GetLabel()
	local c=e:GetHandler()
	local point=c:GetFlagEffectLabel(10001100)
	if not point then
		c:RegisterFlagEffect(10001100,0,EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE,1,pt,aux.Stringid(101010401,0))
	else
		c:SetFlagEffectLabel(10001100,point+pt)
	end
end
function c101010401.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c101010401.actcon(e)
	local tc=Duel.GetAttacker()
	return tc and tc:IsSetCard(0x50b) and tc:GetOriginalRace()==RACE_DRAGON
end
function c101010401.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	local c=e:GetHandler()
	local point=c:GetFlagEffectLabel(10001100)
	if chk==0 then return c:GetFlagEffect(10001100)>ct-1 end
	if point==ct then
		c:ResetFlagEffect(10001100)
	else
		c:SetFlagEffectLabel(10001100,point-ct)
	end
	Debug.ShowHint(tostring(ct) .. " Point(s) removed")
end
function c101010401.filter(c,e,tp)
	return c:IsRace(RACE_DRAGON) and c:IsSetCard(0x50b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101010401.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101010401.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c101010401.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101010401.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
