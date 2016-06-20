--Victorial Dragon Dragotaurus
local id,ref=GIR()
function ref.start(c)
c:EnableReviveLimit()
	--damage
	local ae2=Effect.CreateEffect(c)
	ae2:SetCategory(CATEGORY_DAMAGE)
	ae2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	ae2:SetCode(EVENT_ATTACK_ANNOUNCE)
	ae2:SetLabel(1)
	ae2:SetCost(ref.cost)
	ae2:SetTarget(ref.damtg)
	ae2:SetOperation(ref.damop)
	c:RegisterEffect(ae2)
	--Do Not Remove
	local point=Effect.CreateEffect(c)
	point:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	point:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	point:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	point:SetRange(0xff)
	point:SetCountLimit(1)
	point:SetOperation(ref.ipoint)
	c:RegisterEffect(point)
	--redirect (Do Not Remove)
	local ge0=Effect.CreateEffect(c)
	ge0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	ge0:SetCode(EFFECT_SEND_REPLACE)
	ge0:SetRange(LOCATION_ONFIELD)
	ge0:SetTarget(ref.reen)
	ge0:SetOperation(ref.reenop)
	c:RegisterEffect(ge0)
	--counter (Do Not Remove)
	if not relay_check then
		relay_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(ref.recount)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ATTACK_DISABLED)
		ge2:SetOperation(ref.recheck)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_BATTLED)
		ge3:SetOperation(ref.recount2)
		Duel.RegisterEffect(ge3,0)
	end
	--relay summon (Do Not Remove)
	local ge4=Effect.CreateEffect(c)
	ge4:SetDescription(aux.Stringid(101010401,4))
	ge4:SetType(EFFECT_TYPE_FIELD)
	ge4:SetCode(EFFECT_SPSUMMON_PROC_G)
	ge4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	ge4:SetRange(LOCATION_EXTRA)
	ge4:SetCountLimit(1,10001000)
	ge4:SetCondition(ref.rescon)
	ge4:SetOperation(ref.resop)
	ge4:SetValue(0x8773)
	c:RegisterEffect(ge4)
	--check collected points (Do Not Remove)
	local ge5=Effect.CreateEffect(c)
	ge5:SetDescription(aux.Stringid(101010401,2))
	ge5:SetType(EFFECT_TYPE_IGNITION)
	ge5:SetRange(LOCATION_MZONE)
	ge5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_BOTH_SIDE)
	ge5:SetTarget(ref.pointchk)
	ge5:SetOperation(ref.point)
	c:RegisterEffect(ge5)
	--identifier (Do Not Remove)
	local ge6=Effect.CreateEffect(c)
	ge6:SetType(EFFECT_TYPE_SINGLE)
	ge6:SetCode(10001000)
	c:RegisterEffect(ge6)
end
function ref.ipoint(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(10001100)==0 then
		c:RegisterFlagEffect(10001100,0,EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE,1,2,aux.Stringid(101010401,1))
	end
end
function ref.pointchk(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(10001100)>0 and not c:IsStatus(STATUS_CHAINING) end
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end
function ref.point(e,tp,eg,ep,ev,re,r,rp)
	Debug.ShowHint("Number of Points: " .. tostring(e:GetHandler():GetFlagEffectLabel(10001100)))
end
function ref.reen(e,tp,eg,ep,ev,re,r,rp,chk)
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
function ref.recount(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local ct=tc:GetFlagEffectLabel(10001000)
	if ct then
		tc:SetFlagEffectLabel(10001000,ct+1)
	else
		tc:RegisterFlagEffect(10001000,RESET_PHASE+PHASE_END,0,1,1)
	end
end
function ref.recheck(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local ct=tc:GetFlagEffectLabel(10001000)
	if ct then
		tc:SetFlagEffectLabel(10001000,0)
	end
end
function ref.recount2(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,10001000,RESET_PHASE+PHASE_END,0,1)
end
function ref.resfilter(c)
	if c:IsLocation(LOCATION_REMOVED) and c:IsFacedown() then return false end
	return c:GetFlagEffect(10001000)>0 and c:GetFlagEffectLabel(10001000)>0 and c:IsAbleToDeck() and not (c:IsType(TYPE_PENDULUM) and c:IsHasEffect(10001000))
end
function ref.rescon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(ref.resfilter,tp,0xbe,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=-g:FilterCount(Card.IsLocation,nil,LOCATION_MZONE) then return false end
	return g:GetCount()>0 and Duel.IsExistingMatchingCard(ref.refilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
end
function ref.fdfilter(c)
	return c:IsFacedown() or c:IsLocation(LOCATION_HAND)
end
function ref.refilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
		and c:IsHasEffect(10001000) and not c:IsForbidden()
end
function ref.refilter1(c,e,tp)
	return not c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ) and ref.refilter(c,e,tp)
end
function ref.refilter2(c,e,tp)
	return c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ) and ref.refilter(c,e,tp)
end
function ref.resop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local g=Duel.GetMatchingGroup(ref.resfilter,tp,0xbe,0,nil)
	local fg=g:Filter(ref.fdfilter,nil)
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
	if Duel.IsExistingMatchingCard(ref.refilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(101010401,5)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local rg=Duel.SelectMatchingCard(tp,ref.refilter1,tp,LOCATION_EXTRA,0,1,ft,nil,e,tp)
		sg:Merge(rg)
	end
	if (not rg or ft>rg:GetCount()) and Duel.IsExistingMatchingCard(ref.refilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp) and (not rg or Duel.SelectYesNo(tp,aux.Stringid(101010401,1))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local pc=Duel.SelectMatchingCard(tp,ref.refilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
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
		e1:SetOperation(ref.pointop)
		sc:RegisterEffect(e1)
		sc=sg:GetNext()
	end
end
function ref.pointop(e,tp,eg,ep,ev,re,r,rp)
	local pt=e:GetLabel()
	local c=e:GetHandler()
	local point=c:GetFlagEffectLabel(10001100)
	if not point then
		c:RegisterFlagEffect(10001100,0,EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE,1,pt,aux.Stringid(101010401,0))
	else
		c:SetFlagEffectLabel(10001100,point+pt)
	end
end
function ref.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	local c=e:GetHandler()
	local point=c:GetFlagEffectLabel(10001100)
	if chk==0 then return c:GetFlagEffect(10001100)>=ct end
	if point==ct then
		c:ResetFlagEffect(10001100)
	else
		c:SetFlagEffectLabel(10001100,point-ct)
	end
	Debug.ShowHint(tostring(ct) .. " Point(s) removed")
end
function ref.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x50b)
end
function ref.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local bc=Duel.GetAttackTarget()
	if chk==0 then return bc~=nil end
	local atk1=c:GetAttack()
	local atk2=bc:GetAttack()
	local ct=Duel.GetMatchingGroupCount(ref.filter,tp,LOCATION_MZONE,0,nil)*500
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,math.abs(atk1-atk2)+ct)
end
function ref.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=Duel.GetAttackTarget()
	if c:IsRelateToBattle() and bc:IsFaceup() and bc:IsRelateToBattle() then
		local atk1=c:GetAttack()
		local atk2=bc:GetAttack()
		local ct=Duel.GetMatchingGroupCount(ref.filter,tp,LOCATION_MZONE,0,nil)*500
		Duel.Damage(1-tp,math.abs(atk1-atk2)+ct,REASON_EFFECT)
	end
end

