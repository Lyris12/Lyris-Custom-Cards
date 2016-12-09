--created & coded by Lyris
--Earth Enforcer Leader Sacagawea
function c101010048.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c101010046.xcon)
	e0:SetTarget(c101010046.xtg)
	e0:SetOperation(aux.XyzOperation(aux.FilterBoolFunction(Card.IsSetCard,0xeeb),0,3,3))
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	--Cannot be targeted by card effects.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--While you control another face-up "Earth Enforcer" monster, your opponent cannot Set cards.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_MSET)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetCondition(c101010048.sealcon1)
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
	e5:SetTarget(c101010048.sumlimit)
	c:RegisterEffect(e5)
	--Change all Defense Position WATER, FIRE, and WIND monsters to Attack Position.
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_SET_POSITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTarget(c101010048.postg)
	e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e6:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e6)
	--All WATER, FIRE, and WIND monsters on the field must attack, if able.
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_MUST_ATTACK)
	e7:SetRange(LOCATION_FZONE)
	e7:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e7:SetTarget(c101010048.postg)
	c:RegisterEffect(e7)
	--While you control another monster, your opponent cannot target this card for attacks.
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e8:SetCondition(function(e) return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)>=2 end)
	e8:SetValue(aux.imval1)
	c:RegisterEffect(e8)
end
function c101010048.xfilter(c,tc)
	return c:IsCanBeXyzMaterial(tc) and c:IsSetCard(0xeeb)
end
function c101010048.xcon(e,c,og)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=-3 then return false end
	local g=Duel.GetMatchingGroup(c101010048.xfilter,tp,LOCATION_MZONE,0,1,nil,c)
	return g:GetClassCount(Card.GetLevel)>=3
end
function c101010048.lvfilter(c,lv)
	return c:GetLevel()==lv
end
function c101010048.xtg(e,tp,eg,ep,ev,re,r,rp,chk,c,og)
	local sg=Duel.GetMatchingGroup(c101010048.xfilter,tp,LOCATION_MZONE,0,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=sg:Select(tp,1,1,nil)
	sg:Remove(c101010048.lvfilter,nil,g:GetFirst():GetLevel())
	for i=1,3-1 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g2=sg:Select(tp,1,1,nil)
		g:Merge(g2)
		sg:Remove(c101010048.lvfilter,nil,g2:GetFirst():GetLevel())
		if sg:GetCount()==0 then break end
	end
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function c101010048.xmfilter(c)
	return not (c:IsSetCard(0xeeb) and c:IsType(TYPE_MONSTER))
end
function c101010048.xmatcon(e)
	return not e:GetHandler():GetOverlayGroup():IsExists(c101010048.xmfilter,1,nil)
end
function c101010048.sfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0xeeb)
end
function c101010048.sealcon1(e,tp,eg,ep,ev,re,r,rp)
	return c101010048.xmatcon(e) and Duel.IsExistingMatchingCard(c101010048.sfilter1,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c101010048.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return bit.band(sumpos,POS_FACEDOWN)>0
end
function c101010048.postg(e,c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE+ATTRIBUTE_WATER+ATTRIBUTE_WIND)