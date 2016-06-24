--サイバー・スター・ドラゴン
local id,ref=GIR()
function ref.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeRep(c,70095154,5,false,false)
	--pendulum summon (regular)
	aux.EnablePendulumAttribute(c,false)
	--pendulum summon (special)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetDescription(aux.Stringid(101010020,0))
	e3:SetCode(EFFECT_SPSUMMON_PROC_G)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,101010020)
	e3:SetCondition(ref.pscon)
	e3:SetOperation(ref.psop)
	e3:SetValue(SUMMON_TYPE_PENDULUM)
	c:RegisterEffect(e3)
	--invincibility (spell)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(2)
	e4:SetTarget(ref.target)
	e4:SetValue(ref.value)
	c:RegisterEffect(e4)
	--cannot special summon
	local e5=Effect.CreateEffect(c)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_SPSUMMON_CONDITION)
	e5:SetValue(ref.spslimit)
	c:RegisterEffect(e5)
	--move to Pendulum Scale
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(ref.sdcon)
	e1:SetOperation(ref.sdop)
	c:RegisterEffect(e1)
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(101010020,ACTIVITY_SPSUMMON,ref.counterfilter)
end
function ref.counterfilter(c)
	return c:IsRace(RACE_MACHINE)
end
function ref.sdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function ref.sdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc1=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,6)
	local tc2=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,7)
	if tc1 and tc2 then Duel.Destroy(c,REASON_EFFECT) return end
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
function ref.filter(c,tp)
	return c:IsFaceup() and c:GetPreviousLocation()==LOCATION_EXTRA and c:IsRace(RACE_MACHINE) and c:IsControler(tp) and c:IsReason(REASON_BATTLE)
end
function ref.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(ref.filter,1,nil,tp) end
	return true
end
function ref.value(e,c)
	return ref.filter(c,e:GetHandlerPlayer())
end
function ref.psfilter(c,e,tp,lscale,rscale)
	local lv=0
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	return (c:IsRace(RACE_MACHINE) and (c:IsLocation(LOCATION_HAND+LOCATION_REMOVED) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM))))
	and lv>lscale and lv<rscale and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false) and not c:IsForbidden()
end
function ref.pscon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	if c:GetSequence()~=6 then return false end
	local rpz=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if rpz==nil then return false end
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return false end
	if c:IsForbidden() then return false end
	if Duel.GetCustomActivityCount(101010020,tp,ACTIVITY_SPSUMMON)~=0 then return false end
	if og then
		return og:IsExists(ref.psfilter,1,nil,e,tp,lscale,rscale)
		else
		return Duel.IsExistingMatchingCard(ref.psfilter,tp,LOCATION_HAND+LOCATION_EXTRA+LOCATION_REMOVED,0,1,nil,e,tp,lscale,rscale)
	end
end
function ref.psop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local rpz=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if og then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=og:FilterSelect(tp,ref.psfilter,1,ft,nil,e,tp,lscale,rscale)
		sg:Merge(g)
		else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,ref.psfilter,tp,LOCATION_HAND+LOCATION_EXTRA+LOCATION_REMOVED,0,1,ft,nil,e,tp,lscale,rscale)
		sg:Merge(g)
	end
	Duel.HintSelection(Group.FromCards(c))
	Duel.HintSelection(Group.FromCards(rpz))
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(ref.splimit)
	Duel.RegisterEffect(e1,tp)
end
function ref.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:GetRace()~=RACE_MACHINE
end
function ref.spslimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
