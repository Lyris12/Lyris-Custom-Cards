--EEL・サキャゲーウィー
local id,ref=GIR()
function ref.start(c)
aux.EnablePendulumAttribute(c,false)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(ref.xcon)
	e0:SetTarget(ref.xtg)
	e0:SetOperation(aux.XyzOperation(aux.FilterBoolFunction(Card.IsSetCard,0xeeb),0,3,3))
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	--cannot target
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetValue(aux.tgval)
	c:RegisterEffect(e7)
	--While you control another face-up "Earth Enforcer" monster, your opponent cannot Set cards.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_MSET)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetLabel(1)
	e2:SetCondition(ref.con)
	e2:SetTarget(aux.TRUE)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_SSET)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_TURN_SET)
	c:RegisterEffect(e4)
	local e5=e2:Clone()
	e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e5:SetTarget(ref.sumlimit)
	c:RegisterEffect(e5)
	--All WATER, FIRE, and WIND monsters on the field must attack, if able.
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_MUST_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_FIRE+ATTRIBUTE_WATER+ATTRIBUTE_WIND))
	c:RegisterEffect(e4)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_EP)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(0,1)
	e6:SetCondition(ref.atcon)
	c:RegisterEffect(e6)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_POSITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(function(e,c) return c:IsPosition(POS_FACEUP_DEFENCE) and c:IsAttribute(ATTRIBUTE_FIRE+ATTRIBUTE_WATER+ATTRIBUTE_WIND) end)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e1)
	--While you control another monster, your opponent cannot target this card for attacks.
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e5:SetCondition(ref.ccon)
	e5:SetValue(aux.imval1)
	c:RegisterEffect(e5)
end
ref.pendulum_level=5
function ref.xfilter(c,tc)
	return c:IsSetCard(0xeeb) and c:IsCanBeXyzMaterial(tc)
end
function ref.xcon(e,c,og)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=-3 then return false end
	local g=Duel.GetMatchingGroup(ref.xfilter,tp,LOCATION_MZONE,0,1,nil,c)
	return g:GetClassCount(Card.GetLevel)>2
end
function ref.lvfilter(c,lv)
	return c:GetLevel()==lv
end
function ref.xtg(e,tp,eg,ep,ev,re,r,rp,chk,c,og)
	local sg=Duel.GetMatchingGroup(ref.xfilter,tp,LOCATION_MZONE,0,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=sg:Select(tp,1,1,nil)
	sg:Remove(ref.lvfilter,nil,g:GetFirst():GetLevel())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g2=sg:Select(tp,1,1,nil)
	sg:Remove(ref.lvfilter,nil,g2:GetFirst():GetLevel())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g3=sg:Select(tp,1,1,nil)
	g:Merge(g2)
	g:Merge(g3)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function ref.cfilter(c)
	return not c:IsSetCard(0xeeb) or c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function ref.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return bit.band(sumpos,POS_FACEDOWN)>0
end
function ref.con(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 and not Duel.IsExistingMatchingCard(ref.efilter,tp,LOCATION_MZONE,0,1,e:GetHandler(),1) then return false end
	if e:GetLabel()==2 and not Duel.IsExistingMatchingCard(ref.efilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,0) then return false end
	local g=e:GetHandler():GetOverlayGroup()
	return g:GetCount()>0 and not g:IsExists(ref.cfilter,1,nil)
end
function ref.filter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE+ATTRIBUTE_WATER+ATTRIBUTE_WIND) and c:IsAttackable()
end
function ref.atcon(e)
	return Duel.IsExistingMatchingCard(ref.filter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function ref.ccon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)>1
end
