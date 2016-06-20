--ＳＳ－Ｓ・Ｖｉｎｅ スターモス
local id,ref=GIR()
function ref.start(c)
--synchro
	local ae1=Effect.CreateEffect(c)
	ae1:SetType(EFFECT_TYPE_SINGLE)
	ae1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ae1:SetCode(EFFECT_ADD_TYPE)
	ae1:SetValue(TYPE_SYNCHRO)
	ae1:SetCondition(ref.atcon)
	c:RegisterEffect(ae1)
	--boost
	local ae2=Effect.CreateEffect(c)
	ae2:SetType(EFFECT_TYPE_FIELD)
	ae2:SetCode(EFFECT_UPDATE_ATTACK)
	ae2:SetRange(LOCATION_MZONE)
	ae2:SetTargetRange(LOCATION_MZONE,0)
	ae2:SetTarget(ref.syntg)
	ae2:SetValue(1000)
	c:RegisterEffect(ae2)
	--special summon (Do Not Remove)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(ref.spcon)
	e1:SetOperation(ref.spop)
	e1:SetValue(SUMMON_TYPE_XYZ+0x7150)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(function(e,se,ep,st) return bit.band(st,SUMMON_TYPE_XYZ+0x7150)==SUMMON_TYPE_XYZ+0x7150 end)
	c:RegisterEffect(e2)
	--cannot Grave (Do Not Remove)
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD)
	ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_RANGE)
	ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	ge1:SetTargetRange(LOCATION_ONFIELD+LOCATION_OVERLAY,0)
	ge1:SetTarget(function(e,c) return c==e:GetHandler() end)
	ge1:SetValue(LOCATION_REMOVED)
	Duel.RegisterEffect(ge1,0)
end
function ref.sfilter(c)
	return c:IsNotTuner() and c:IsAbleToRemoveAsCost()
end
function ref.spfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_TUNER) and Duel.IsExistingMatchingCard(ref.sfilter,tp,LOCATION_MZONE,0,1,c)
end
function ref.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2 and Duel.IsExistingMatchingCard(ref.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
function ref.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(ref.spfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc1=g:Select(tp,1,1,nil)
	g:Remove(Card.IsType,nil,TYPE_TUNER)
	g:Merge(Duel.GetMatchingGroup(ref.sfilter,tp,LOCATION_MZONE,0,tc1:GetFirst()))
	local tc2=g:Select(tp,1,1,nil)
	local atk2=tc2:GetFirst():GetAttack()
	tc1:Merge(tc2)
	c:SetMaterial(tc1)
	local fg=tc1:Filter(Card.IsFacedown,nil)
	if fg:GetCount()>0 then Duel.ConfirmCards(1-tp,fg) end
	local atk=0
	local tc=tc1:GetFirst()
	while tc do
		local atk1=tc:GetDefence()
		atk=atk+atk1
		tc=tc1:GetNext()
	end
	Duel.Remove(tc1,POS_FACEUP,REASON_MATERIAL+0x7150)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_DEFENCE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(atk)
	c:RegisterEffect(e1)
end
function ref.atcon(e,tp)
	return Duel.GetTurnPlayer()==tp
end
function ref.syntg(e,c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c~=e:GetHandler()
end