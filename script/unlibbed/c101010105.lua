--FF－ファルコン・ラプター
function c101010562.initial_effect(c)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(c101010562.con)
	e0:SetCost(c101010562.cost)
	e0:SetOperation(c101010562.spellop)
	c:RegisterEffect(e0)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c101010562.ffilter1,c101010562.ffilter2,true)
end
function c101010562.ffilter1(c)
	return c:IsAttribute(ATTRIBUTE_DARK) or (c:IsHasEffect(101010560) and not c:IsLocation(LOCATION_DECK))
end
function c101010562.ffilter2(c)
	return c:IsRace(RACE_WINDBEAST) or (c:IsHasEffect(101010576) and not c:IsLocation(LOCATION_DECK))
end
function c101010562.con(e,tp)
	return Duel.GetTurnPlayer()~=tp
end
function c101010562.filter(c)
	return (c:GetType()==TYPE_SPELL or c:GetType()==TYPE_TRAP) and c:IsAbleToRemove()
end
function c101010562.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c101010562.filter,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectTarget(tp,c101010562.filter,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
	if e:GetHandler():IsHasEffect(101010552) then
		Duel.SetChainLimit(c101010562.limit(tc:GetFirst()))
	end
end
function c101010562.limit(c)
	return  function (e,lp,tp)
				return e:GetHandler()~=c
			end
end
function c101010562.spellop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
		local code=tc:GetCode()
		while code>99 do code=math.floor(code/10) end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(code*100)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end
